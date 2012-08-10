
/**
 * Module dependencies.
 */

var express		= require('express'),
		http			= require('http'),
		assets		= require('connect-assets'),
		mongojs		= require('mongojs'),
		pass			= require('pwd'),
		path			= require('path');

/**
 * Declare our app.
 */
var app = express();

/**
 * Set up our database.
 */
var database = 'govtest',
		collections = ["attendees", "workshops"],
		db = mongojs.connect(database, collections);

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

// Set up Login.
app.get('/login', function(req,res){
	res.render('index'); // Angular does this.
});

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
		db.attendees.find(function(err, attendees){
		if( err || !attendees) console.log("No attendees found");
		else
			res.send(attendees);				
	});	
});

// Get a list of workshops
app.get('/workshops', function(req, res){
	db.workshops.find(function(err, attendees) {
		if ( err || !workshops ) console.log("No workshops found");
		else
			res.send(workshops);
	});
});

function authenticate(name, password, fn){
  if (!module.parent) console.log('authenticating %s:%s', name, password);
  db.attendees.findOne({name: name}, function (err, user){
		// query the db for the given username
		if (!user) return fn(new Error('cannot find user'));
		// apply the same algorithm to the POSTed password, applying
		// the hash against the pass / salt, if there is a match we
		// found the user
		pass.hash(password, user.salt, function(err, hash){
			if (err) return fn(err);
			if (hash == user.hash) return fn(null, user);
			fn(new Error('invalid password'));
		})
	})
}
// Login Form Post
app.post('/login', function(req,res){
	authenticate(req.body.username, req.body.password, function(err, user){
		console.log(user);
		if (user) {
      // Regenerate session when signing in
      // to prevent fixation 
      req.session.regenerate(function(){
        // Store the user's primary key 
        // in the session store to be retrieved,
        // or in this case the entire user object
        req.session.user = user;
        res.redirect('back');
      });
    } else {
      req.session.error = 'Authentication failed, please check your '
        + ' username and password.'
        + ' (use "tj" and "foobar")';
      res.redirect('login');
    }
  });

});

// Registration Form Post
app.post('/register', function(req, res){
/*		pass.hash(req.body.password, function(err, returnedSalt, returnedHash){
			db.attendees.save(
			{
				name			: req.body.name,
				salt			:	returnedSalt,
				hash			: returnedHash,
				info			: 
					{
						address		: req.body.address,
						city			: req.body.city,
						phone			: req.body.phone,
						email			: req.body.email
					},
				attendees			:	{}
			});
		});
*/
	db.attendees.save(req.primaryContact);
	}
);


/**
 * Finally, start the server.
 */
http.createServer(app).listen(app.get('port'), function(){
	console.log("Express server listening on port " + app.get('port'));
});
