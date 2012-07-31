
/**
 * Module dependencies.
 */

var express = require('express'),
	http = require('http'),
	assets = require('connect-assets'),
	path = require('path');

/**
 * Declare our app.
 */
var app = express();

/**
 * Set up our database.
 */
var database = 'govtest',
		collections = ["gov"],
		db = require("mongojs").connect(database, collections);

/**
 * Persistant configuration goes here.
 */
app.configure(function(){
	app.set('port', process.env.PORT || 8080);
	app.set('views', __dirname + '/views');
	app.set('view engine', 'jade');
	app.use(express.favicon());
	app.use(express.logger('dev'));
	app.use(express.bodyParser());
	app.use(express.methodOverride());
	app.use(assets());
	app.use(express.cookieParser('Hoverbear was here.'));
	app.use(express.session());
	app.use(app.router);
	app.use(express.static(path.join(__dirname, 'public')));
});

/** 
 * Configuration changes go here,
 */
app.configure('development', function(){
	app.use(express.errorHandler());
});

/**
 * Routes go here.
 */
app.get('/', function(req, res){
	  res.render('index', { title: 'Express' });
	}
);

// All partials are accessed via this.
app.get('/partials/:name', function(req, res){
		var name = req.params.name;
		res.render('partials/' + name)
	}
);

// Set up register.
app.get('/register', function(req, res){
		res.render('index'); // Angular JS handles this, we just need to provide the route.
	}
);

// See the backend database.
app.get('/management', function(req, res){
		res.render('index'); // Angular takes care of this.
	}
);

// Get a list of attendees.
app.get('/attendees', function(req, res){
		db.gov.find(function(err, attendees){
			if( err || !attendees) console.log("No attendees found");
			else
					res.send(attendees); 				
			});	
		});

//Form Stuff
app.post('/register', function(req, res){
		db.gov.save(req.body);
	}
);

/**
 * Finally, start the server.
 */
http.createServer(app).listen(app.get('port'), function(){
	console.log("Express server listening on port " + app.get('port'));
});
