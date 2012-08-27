###
# Module dependencies.
###
express = require("express")
http = require("http")
assets = require("connect-assets")
mongojs = require("mongojs")
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
database = config.database
collections = ["attendees"]
db = mongojs.connect(database, collections)

###
# Persistant configuration goes here.
###
app.configure ->
  app.set "port", config.port or 8080
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
