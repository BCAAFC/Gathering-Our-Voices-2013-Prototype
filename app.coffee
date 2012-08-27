###
# Module dependencies.
###
express = require("express")
http = require("http")
assets = require("connect-assets")
mongoose = require("mongoose")
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
database = mongoose.createConnection('localhost', config.database)
database.on 'error', console.error.bind(console, 'connection error:')
database.once 'open', () ->
  console.log "Connected to Database."

# Attendee Schema used for youth, chaperones, and young adults
attendeeSchema = new mongoose.Schema
  name: String
  status: String
  gender: String
  birthDate: String
  phone: Number
  email: String
  emergencyInfo:
    name: String
    relation: String
    phone: Number
    medicalNum: Number
    allergies: [String]
    illnesses: [String]
  number: Number
Attendee = database.model('Attendee', attendeeSchema)

# Group Schema for all groups.
groupSchema = new mongoose.Schema
  primaryContact:
    name: String
    phone: Number
    email: String
    extendedInfo:
      affiliation: String
      address: String
      city: String
      province: String
      postalCode: String
      fax: Number
  youthList: [attendeeSchema]
  chaperoneList: [attendeeSchema]
  youngAdultList: [attendeeSchema]
  costs:         
    paidTickets: Number
    freeTickets: Number
    paid: Number
Group = database.model('Group', groupSchema)

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
    Group.find {}, (err, result) ->
      if err
        console.log err
      res.send result

# Registration Form Post
app.post "/register",
  (req, res) ->
    group = new Group
      primaryContact: req.body.primaryContact
      youthList: req.body.youthList
      chaperoneList: req.body.chaperoneList
      youngAdultList: req.body.youngAdultList
      costs: req.costs
    # Catch errors and send a message
    group.save (err) ->
      if (err)
        console.log "Error in validation!"
        console.log err
        res.send
          success: false
      else
        res.send
          success: true

###
# Finally, start the server.
###
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
