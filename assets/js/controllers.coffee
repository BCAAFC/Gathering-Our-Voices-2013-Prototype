"use strict"
# Controllers 

###
# Managment Controller. This handles the database viewer.
###
@manCtl = ($scope, $http, secret) ->
	$scope.secret = secret.get()
	$scope.auth = ->
		secret.set($scope.secret)
		$http.post("/attendee-list",
			secret: $scope.secret
		).success (data, status, headers, config) ->
			$scope.attendees = data
			$scope.totalYouth = () ->
				total = 0
				for group in $scope.attendees
					total += group.youthList.length
				return total
			$scope.totalChaperones = () ->
				total = 0
				for group in $scope.attendees
					total += group.chaperoneList.length
				return total
			$scope.totalYoungAdults = () ->
				total = 0
				for group in $scope.attendees
					total += group.youngAdultList.length
				return total

	$scope.select = (attendee) ->
		$scope.currentUser = attendee
		
	$scope.selectGroup = (group) ->
		$scope.selectedGroup = group
		
	$scope.remove = (group) ->
		# Send the group to be removed. We trim the data to avoid booleans we sometimes use.
		$http.post("/removeGroupById",
			secret: $scope.secret
			id: group._id
		).success (data, status, headers, config) ->
			$scope.auth()
			$scope.selectedGroup = ""
			
	$scope.updateInternals = (group) ->
		$http.post("/updateInternals",
			secret: $scope.secret
			id: group._id
			internalData: group.internalData
		).success (data, status, headers, config) ->
			group.updateSuccess = data.success

###
# Login Controller. Handles logins, so it's sort of a big deal.
###
@loginCtl = ($scope, $http) ->
	$scope.login = ->
		$http.post "/login",
			username: $scope.username
			password: $scope.password

###
# Register Controller. This handles the entire registration form.
# It may be wise to find a cleaner format for this.
###
@regCtl = ($scope, $http, $routeParams, $location) ->
	# Initialize our Lists to empty
	# We load empty data to avoid errors with some of our functions.
	# It gets overridden if we're loading data from a user.
	$scope.youthList = []
	$scope.chaperoneList = []
	$scope.youngAdultList = []
	# Define an empty primary contact
	$scope.primaryContact =
		name: ""
		phone: ""
		email: ""
	$scope.groupInfo =
		affiliation: ""
		address: ""
		city: ""
		province: ""
		postalCode: ""
		fax: ""
	$scope.costs =
		paymentMethod: ""
			
	# By default, we're doing a new registration
	$scope.updateButton = false
	# Detect if this is an update
	if $routeParams.groupId
		$http.post("/getGroupId",
			id: $routeParams.groupId
		).success (data, status, headers, config) ->
			console.log data
			# Set the lists up to load from data
			$scope.youthList = data.youthList
			$scope.chaperoneList = data.chaperoneList
			$scope.youngAdultList = data.youngAdultList
			# Load up our Primary Contact
			$scope.primaryContact = data.primaryContact
			$scope.groupInfo = data.groupInfo
			$scope.costs.paymentMethod = data.costs.paymentMethod
			# Set something so we know to update, not newly register.
			$scope.updateButton = true
	
	# Define the submit button
	$scope.submit = ->
		if $scope.updateButton
			$http.post("/update",
				primaryContact: $scope.primaryContact
				groupInfo: $scope.groupInfo
				youthList: $scope.youthList
				chaperoneList: $scope.chaperoneList
				youngAdultList: $scope.youngAdultList
				internalData: ""
				oldId: $routeParams.groupId
				costs:
					paidTickets: $scope.paidTickets()
					freeTickets: $scope.freeTickets()
					paymentMethod: $scope.costs.paymentMethod
			).success (data, status, headers, config) ->
				if data.success == false
					$scope.submitError = true
					$scope.validationErrors = data.errors
					console.log "Please send the following if asked by an IT person:"
					console.log data
				else
					$scope.submitted = true
					$scope.submitError = false
		else
			$http.post("/register",
				primaryContact: $scope.primaryContact
				groupInfo: $scope.groupInfo
				youthList: $scope.youthList
				chaperoneList: $scope.chaperoneList
				youngAdultList: $scope.youngAdultList
				internalData: ""
				costs:
					paidTickets: $scope.paidTickets()
					freeTickets: $scope.freeTickets()
					paymentMethod: $scope.costs.paymentMethod
			).success (data, status, headers, config) ->
				if data.success == false
					$scope.submitError = true
					$scope.validationErrors = data.errors
					console.log "Please send the following if asked by an IT person:"
					console.log data
				else
					$scope.submitted = true
					$scope.submitError = false
	
	# Youth list
	$scope.addYouth = ->
		$scope.youthList.push
			name: "New Youth"
			status: "Youth (14-17 yrs)"
			gender: ""
			birthDate: ""
			phone: ""
			email: ""
			emergencyInfo:
				name: ""
				relation: ""
				phone: ""
				medicalNum: ""
				allergies: ""
				illnesses: ""
	
	# Chaperone list
	$scope.addChaperone = ->
		$scope.chaperoneList.push
			name: "New Chaperone"
			status: "Chaperone (21+ yrs)"
			gender: ""
			birthDate: ""
			phone: ""
			email: ""
			emergencyInfo:
				name: ""
				relation: ""
				phone: ""
				medicalNum: ""
				allergies: ""
				illnesses: ""
	
	# Young Adult list
	$scope.addYoungAdult = ->
		$scope.youngAdultList.push
			name: "New Young Adult"
			status: "Young Adult (18-24 yrs)"
			gender: ""
			birthDate: ""
			phone: ""
			email: ""
			emergencyInfo:
				name: ""
				relation: ""
				phone: ""
				medicalNum: ""
				allergies: ""
				illnesses: ""
	
	$scope.removeYouth = (youth) ->
		removal = $scope.youthList.indexOf(youth)
		$scope.youthList.splice(removal,1)
		
	$scope.removeChaperone = (chaperone) ->
		removal = $scope.chaperoneList.indexOf(chaperone)
		$scope.chaperoneList.splice(removal,1)
		
	$scope.removeYoungAdult = (youngAdult) ->
		removal = $scope.youngAdultList.indexOf(youngAdult)
		$scope.youngAdultList.splice(removal,1)
	
	$scope.numberOfAttendees = () ->
		$scope.youthList.length + $scope.chaperoneList.length + $scope.youngAdultList.length
	
	$scope.freeTickets = () ->
		Math.floor( $scope.numberOfAttendees() / 6 )
	$scope.paidTickets = () ->
		$scope.numberOfAttendees() - $scope.freeTickets()
		
	$scope.totalCost = () ->
		$scope.paidTickets() * 175

	$scope.enoughChaperones = () ->
		$scope.chaperoneList.length >= Math.ceil($scope.youthList.length / 5)

regCtl.$inject = ["$scope", "$http", "$routeParams", "$location"]

###
# Table controllers
###
@groupTableCtl = ($scope, $http, $routeParams, secret) ->
	$scope.secret = secret.get()
	$http.post("/attendee-list",
		secret: $scope.secret
	).success (data, status, headers, config) ->
		$scope.attendees = data
groupTableCtl.$inject = ["$scope", "$http", "$routeParams", "secret"]

@attendeeTableCtl = ($scope, $http, $routeParams, secret) ->
	$scope.secret = secret.get()
	$http.post("/attendee-list",
		secret: $scope.secret
	).success (data, status, headers, config) ->
		$scope.attendees = data
attendeeTableCtl.$inject = ["$scope", "$http", "$routeParams", "secret"]

###
# Home, does nothing yet.
###
@homeCtl = ($scope) ->

homeCtl.$inject = ["$scope"]

###
# Privacy, does nothing yet.
###
@privCtl = ($scope) ->

privCtl.$inject = ["$scope"]