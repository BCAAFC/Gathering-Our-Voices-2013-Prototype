"use strict"

# Services 

# Demonstrate how to register services
# In this case it is a simple value service.
angular.module("gov.services", [])
	.factory('secret', ($http) ->
		secret = ''
		secretService =
			set: (newSecret) ->
				secret = newSecret
			get: () ->
				return secret
	)
