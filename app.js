
/**
 * Module dependencies.
 */

var express = require('express'),
	routes = require('./routes'),
	http = require('http'),
	connectassets = require('connect-assets'),
	path = require('path');

/**
 * Declare our app.
 */
var app = express();

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
app.get('/', routes.index);

/**
 * Finally, start the server.
 */
http.createServer(app).listen(app.get('port'), function(){
	console.log("Express server listening on port " + app.get('port'));
});
