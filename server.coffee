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
nodemailer = require("nodemailer")

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
	type: String
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
Attendee = database.model('Attendee', attendeeSchema)

# Group Schema for all groups.
groupSchema = new mongoose.Schema
	primaryContact:
		name: String
		phone: String
		email: String
	groupInfo:
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
		paidTickets: Number
		freeTickets: Number
		paymentMethod: String
	internalData:
		regDate: String
		status: String
		confirmation: String
		workshop: String
		youthInCare: String
		paymentStatus: String
		paid: Number
		feePerTicket: Number
		notes: String
Group = database.model('Group', groupSchema)

###
# Mailer Configuration
###
smtpTransport = nodemailer.createTransport("SMTP",
		host: 'smtp.gmail.com',
		port: 465,
		ssl: true,
		use_authentication: true,
		user: config.mailName,
		pass: config.mailPass
)

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
		
sendMail = (group) ->
	message =
		from: "gatheringourvoices.noreply@gmail.com"
		to: "#{group.primaryContact.email}"
		cc: "dpreston@bcaafc.com"
		subject: "Gathering Our Voices - Registration Confirmation"
		html: "<h1>Hello #{group.primaryContact.name} of the #{group.groupInfo.affiliation}</h1>
		<h3>Thank you for submitting your registration!</h3>
		<p>The Gathering Our Voices team will review your registration and send you an email response which can include the following:</p> <ul><li>Request for missing information</li><li>payment arrangements</li><li>Confirmation of official registration</li></ul>
		<h3>Workshop Registration</h3><p>Workshop Registration will begin early February 2013. Once you receive confirmation your registration is complete an e-mail will be sent notifying you of the list of workshops and next steps in workshop registration.</p>
		<h3>Questions or Concerns</h3>
		<p>If you have any questions or concerns please contact</p>
		<p>Della Preston, Conference Coordinator</p>
		<p>Email: <a href='mailto:dpreston@bcaafc.com'>dpreston@bcaafc.com</a></p>
		<p>Phone: 1-800-990-2432.</p>
		<p>Web Registration: <a href='http://gatheringourvoices.bcaafc.com'>gatheringourvoices.bcaafc.com</a></p>
		<p>Web Information: <a href='http://www.bcaafc.com/newsandevents/gathering-our-voices'>http://www.bcaafc.com/newsandevents/gathering-our-voices</a></p>"
		
	smtpTransport.sendMail message, (error) ->
		if error
			console.log "Error occured"
			console.log error.message
			return
		console.log "Message sent successfully!"


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

# UNCOMMENT THIS TO MAKE AN ERROR PAGE APPEAR EVERYWHERE, then comment out the above and restart server.
#app.get "/:anything", (req,res) ->
#	 res.render "down"

# This handles all the partials for Angular, don't break this!
app.get "/partials/:name", (req, res) ->
	name = req.params.name
	res.render "partials/" + name

app.get "/partials/tables/:name", (req, res) ->
	name = req.params.name
	res.render "partials/tables/" + name

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
	
	
# Privacy GET. Angular Handles the templating.
app.get "/privacy", (req, res) ->
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
	group = new Group
		primaryContact: req.body.primaryContact
		groupInfo: req.body.groupInfo
		youthList: req.body.youthList
		chaperoneList: req.body.chaperoneList
		youngAdultList: req.body.youngAdultList
		costs: req.body.costs
		internalData:
			regDate: new Date()
			status: "New group - Unchecked"
			confirmation: "Unchecked"
			workshop: "WS reg not sent"
			youthInCare: "No, have no asked"
			paymentStatus: "Need to contact"
			paid: 0
			feePerTicket: getTicketPrice()
			notes: ""
	# Catch errors and send a message
	group.save (err) ->
		if (err)
			console.log "Error in validation of a registration"
			res.send
				success: false
				errors: err
		else
			console.log "A new group has been registered."
			res.send
				success: true
			sendMail(group)
					
# Update Form Post
app.post "/update", (req, res) ->
	# Get the old group.
	Group.findOne
		"_id": new ObjectId(req.body.oldId)
		(err, result) ->
			# Once we have the old group, set it.
			result.primaryContact= req.body.primaryContact
			result.groupInfo = req.body.groupInfo
			result.youthList = req.body.youthList
			result.chaperoneList = req.body.chaperoneList
			result.youngAdultList = req.body.youngAdultList
			result.costs = req.body.costs
			result.internalData =
				status: "Edited - Unchecked"
			
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
		Group.findOne { "_id": req.body.id }, (err, result) ->
			if (err)
				console.log "Couldn't find a group!"
			else
			result.remove (err) ->
				if (err)
					console.log "Error in removal!"
					console.log err
					res.send
						success: false
				else
					res.send
						success: true

# Update Group Payment
app.post "/updateInternals", (req, res) ->
	if req.body.secret is config.secret
		Group.findOne { "_id": req.body.id }, (err, result) ->
			result.internalData = req.body.internalData
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