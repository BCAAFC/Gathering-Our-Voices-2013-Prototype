//'use strict';


// Declare app level module which depends on filters, and services
angular.module('gov', ['ui','govmath']).
  config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    $routeProvider.when('/register', {templateUrl: 'partials/register', controller: regCtl});
    $routeProvider.when('/management', {templateUrl: 'partials/management', controller: manCtl});
		$routeProvider.when('/login', {templateUrl: 'partials/login', controller: loginCtl});
		$routeProvider.when('/', {templateUrl: 'partials/home', controller: homeCtl});
		$routeProvider.otherwise({redirectTo: '/'});
    $locationProvider.html5Mode(true);
  }]);

angular.module('govmath', []).
	filter('chaperone', function() {
		return function(num) {
			return Math.ceil(num / 5);
		};
	});
