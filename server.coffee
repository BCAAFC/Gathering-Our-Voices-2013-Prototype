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
ObjectId = require('mongoose').Types.ObjectId;
database.on 'error', console.error.bind(console, 'connection error:')
database.once 'open', () ->
  console.log "Connected to Database."

# Attendee Schema used for youth, chaperones, and young adults
attendeeSchema = new mongoose.Schema
  name: String
  status: String
  gender: String
  birthDate: String
  phone: String
  email: String
  emergencyInfo:
    name: String
    relation: String
    phone: String
    medicalNum: String
    allergies: [String]
    illnesses: [String]
  number: Number
Attendee = database.model('Attendee', attendeeSchema)

# Group Schema for all groups.
groupSchema = new mongoose.Schema
  primaryContact:
    name: String
    phone: String
    email: String
    extendedInfo:
      affiliation: String
      address: String
      city: String
      province: String
      postalCode: String
      fax: String
  youthList: [attendeeSchema]
  chaperoneList: [attendeeSchema]
  youngAdultList: [attendeeSchema]
  costs:
    feePerTicket: Number        
    paidTickets: Number
    freeTickets: Number
    paid: Number
    paymentMethod: String
  internalData:
    youthNumber: Number
    youngAdultNumber: Number
    chaperoneNumber: Number
Group = database.model('Group', groupSchema)

###
# Custom Functions
###
getTicketPrice = () ->
  today = new Date()
  deadline = new Date("Febuary 9, 2012 00:00:00")
  if (today <= deadline)
    return 175
  else
    return 125

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

# Register GET. Angular Handles the templating.
app.get "/register", (req, res) ->
  res.render "index"
  
# Register GET. Angular Handles the templating.
app.get "/register/:groupId", (req, res) ->
  res.render "index"
  
# Home GET. Angular Handles the templating.
app.get "/home", (req, res) ->
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
app.post "/register", (req, res) ->
  console.log req.body.costs.paymentMethod
  group = new Group
    primaryContact: req.body.primaryContact
    youthList: req.body.youthList
    chaperoneList: req.body.chaperoneList
    youngAdultList: req.body.youngAdultList
    costs:
      feePerTicket: getTicketPrice()
      paid: 0
      freeTickets: req.body.costs.freeTickets
      paidTickets: req.body.costs.paidTickets
      paymentMethod: req.body.costs.paymentMethod
    internalData: req.body.internalData
  # Catch errors and send a message
  console.log group
  group.save (err) ->
    if (err)
      console.log "Error in validation of a form!"
      res.send
        success: false
        errors: err
    else
      res.send
        success: true
          
# Update Form Post
app.post "/update", (req, res) ->
  # Get the old group.
  Group.findOne
    "_id": new ObjectId(req.body.oldId)
    (err, result) ->
      # Once we have the old group, set it.
      result.primaryContact= req.body.primaryContact
      result.youthList= req.body.youthList
      result.chaperoneList= req.body.chaperoneList
      result.youngAdultList= req.body.youngAdultList
      result.internalData= req.body.internalData
      result.costs.paidTickets= req.body.costs.paidTickets
      result.costs.freeTickets= req.body.costs.freeTickets
      result.costs.paymentMethod = req.body.costs.paymentMethod
      # Catch errors and send a message
      result.save (err) ->
        console.log err
        if (err)
          console.log "Error in validation!"
          console.log err
          res.send
            success: false
        else
          res.send
            success: true

# Get a group ID
app.post "/getGroupId", (req, res) ->
  Group.findOne { "_id" : req.body.id }, (err, result) ->
    res.send result

# Remove a group
app.post "/removeGroupById", (req, res) ->
  if req.body.secret is config.secret
    Group.findOne req.body.group, (err, result) ->
      result.remove (err) ->
        if (err)
          console.log "Error in removal!"
          console.log err
          res.send
            success: false
        else
          res.send
            success: true

# Remove a group
app.post "/updatePaid", (req, res) ->
  if req.body.secret is config.secret
    Group.findOne { "_id": req.body.group.id }, (err, result) ->
      result.costs = req.body.costs
      result.save (err) ->
        if (err)
          console.log "Error in update!"
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