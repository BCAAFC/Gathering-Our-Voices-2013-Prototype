#'use strict';

# Declare app level module which depends on filters, and services
@angular.module("gov", ["gov.directives", "gov.services", "ui"])
.config(["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
	$routeProvider.when "/register/:groupId",
		templateUrl: "/partials/register"
		controller: regCtl
	
	$routeProvider.when "/register",
		templateUrl: "/partials/register"
		controller: regCtl

	$routeProvider.when "/management",
		templateUrl: "/partials/management"
		controller: manCtl
		
	$routeProvider.when "/groupTable",
		templateUrl: "/partials/tables/groupTable",
		controller: groupTableCtl

	$routeProvider.when "/login",
		templateUrl: "/partials/login"
		controller: loginCtl

	$routeProvider.when "/",
		templateUrl: "/partials/home"
		controller: homeCtl
	
	$routeProvider.when "/privacy",
		templateUrl: "/partials/privacy"
		controller: privCtl

	$routeProvider.otherwise redirectTo: "/"
	$locationProvider.html5Mode true
])
