#'use strict';

# Declare app level module which depends on filters, and services
angular.module("gov", ["ui", "govmath", "bootstrap"])
.config(["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
  $routeProvider.when "/register",
    templateUrl: "partials/register"
    controller: regCtl

  $routeProvider.when "/management",
    templateUrl: "partials/management"
    controller: manCtl

  $routeProvider.when "/login",
    templateUrl: "partials/login"
    controller: loginCtl

  $routeProvider.when "/",
    templateUrl: "partials/home"
    controller: homeCtl

  $routeProvider.otherwise redirectTo: "/"
  $locationProvider.html5Mode true
]).directive("carouselNext", ->
  link: (scope, element, attrs) ->
    element.bind "click", (event) ->
      event.preventDefault()
      $("#intro-carousel").carousel "next"
).directive("carouselPrev", ->
  link: (scope, element, attrs) ->
    element.bind "click", (event) ->
      event.preventDefault()
      $("#intro-carousel").carousel "prev"
).directive('uiScroll', ->
  link: (scope, element, attrs) ->
    element.bind "click", (event) ->
      event.preventDefault()
      goTo = $(attrs.uiScroll).offset().top - 40
      $(window).scrollTop goTo
)
angular.module("govmath", []).filter "chaperone", ->
  (num) ->
    Math.ceil num / 5

