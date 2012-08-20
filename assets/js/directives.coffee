#'use strict';

angular.module("gov.directives", [])
    .directive("carouselNext", ->
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
          goTo = $("#" + attrs.uiScroll).offset().top - 40
          console.log(goTo)
          $(window).scrollTop goTo
    )