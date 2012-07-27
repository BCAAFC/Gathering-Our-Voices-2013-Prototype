# Initializer. This gets called on document load.
$ ->
	# I want a nice fade in, because why not?
	$('.fadeIn').animate
		opacity: 1
		1000
	$('.carousel').carousel
		interval: 10000


# This function sets up the subnav to 'stick' to the top.
$(document).scroll ->
  unless $(".subnav").attr("data-top")
    return  if $(".subnav").hasClass("subnav-fixed")
    offset = $(".subnav").offset()
    $(".subnav").attr "data-top", offset.top
  if $(".subnav").attr("data-top") - $(".subnav").outerHeight() <= $(this).scrollTop()
    $(".subnav").addClass "subnav-fixed"
  else
    $(".subnav").removeClass "subnav-fixed"
