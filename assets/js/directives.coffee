#'use strict';

@angular.module("gov.directives", [])
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
				$(window).scrollTop goTo
	).directive('accordion', ->
		link: (scope, element, attrs) ->
			element.bind "click", (event) ->
				event.preventDefault()
				# Get the accordion group we want, hide the ones we don't want.
				group = attrs.accordionGroup
				$(group).find(".in").collapse "hide"
				# Get the accordion we want, open the one we want.
				select = "#" + attrs.accordion
				$(select).collapse "toggle"
	).directive('uiAffix', ->
		link: (scope, element, attrs) ->
			element.affix
				offset:
					top: 310
	)