'use strict';


// Declare app level module which depends on filters, and services
angular.module('gov', []).
  config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    $routeProvider.when('/register', {templateUrl: 'partials/register', controller: regCtl});
    $routeProvider.when('/', {templateUrl: 'partials/home', controller: homeCtl});
    $routeProvider.otherwise({redirectTo: '/'});
    $locationProvider.html5Mode(true);
  }]);
