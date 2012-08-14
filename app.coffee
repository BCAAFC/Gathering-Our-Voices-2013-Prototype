###
# Module dependencies.
###
express = require("express")
http = require("http")
assets = require("connect-assets")
mongojs = require("mongojs")
pass = require("pwd")
path = require("path")
coffee = require("coffee-script")
config = require("./config")

###
# Declare our app.
###
app = express()

###
# Set up our database.
###
database = "govtest"
collections = ["attendees", "workshops"]
db = mongojs.connect(database, collections)

# Maybe Deprecate
authenticate = (name, password, fn) ->
  console.log "authenticating %s:%s", name, password  unless module.parent
  db.attendees.findOne
    name: name
  , (err, user) ->
    
    # query the db for the given username
    return fn(new Error("cannot find user"))  unless user
    
    # apply the same algorithm to the POSTed password, applying
    # the hash against the pass / salt, if there is a match we
    # found the user
    pass.hash password, user.salt, (err, hash) ->
      return fn(err)  if err
      return fn(null, user)  if hash is user.hash
      fn new Error("invalid password")


###
# Persistant configuration goes here.
###
app.configure ->
  app.set "port", process.env.PORT or 8080
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use assets()
  app.use express.cookieParser(config.cookieSecret)
  app.use express.session()
  app.use app.router
  app.use express.static(path.join(__dirname, "public"))

###
# Configuration changes go here,
###
app.configure "development", ->
  app.use express.errorHandler()

###
# Routes go here.
###
# Index GET.
app.get "/", (req, res) ->
  res.render "index"

# This handles all the partials for Angular, don't break this!
app.get "/partials/:name", (req, res) ->
  name = req.params.name
  res.render "partials/" + name

# Login GET. Angular Handles the templating.
app.get "/login", (req, res) ->
  res.render "index"

# Register GET. Angular Handles the templating.
app.get "/register", (req, res) ->
  res.render "index"

# Management GET. Angular Handles the templating.
app.get "/management", (req, res) ->
  res.render "index"

# Login Form Post
app.post "/login", (req, res) ->
  authenticate req.body.username, req.body.password, (err, user) ->
    console.log user
    if user
      # Regenerate session when signing in
      # to prevent fixation 
      req.session.regenerate ->
        # Store the user's primary key 
        # in the session store to be retrieved,
        # or in this case the entire user object
        req.session.user = user
        res.redirect "back"
    else
      req.session.error = "Authentication failed, please check your " + " username and password." + " (use \"tj\" and \"foobar\")"
      res.redirect "login"

# Management list (User must provide password)
app.post "/attendee-list", (req, res) ->
  if req.body.secret is config.secret
    db.attendees.find {}, (err, attendees) ->
      res.send attendees

# Registration Form Post
app.post "/register", (req, res) ->
  db.attendees.save req.body

###
# Finally, start the server.
###
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

