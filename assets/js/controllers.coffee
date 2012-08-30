"use strict"
# Controllers 

###
# Managment Controller. This handles the database viewer.
###
@manCtl = ($scope, $http) ->
  $scope.auth = ->
    $http.post("/attendee-list",
      secret: $scope.secret
    ).success (data, status, headers, config) ->
      $scope.attendees = data

  $scope.select = (attendee) ->
    $scope.currentUser = attendee
    
  $scope.remove = (group) ->
    # Send the group to be removed. We trim the data to avoid booleans we sometimes use.
    $http.post("/removeGroupById",
      secret: $scope.secret
      group:
        primaryContact: group.primaryContact
        youthList: group.youthList
        youngAdultList: group.youngAdultList
        chaperoneList: group.chaperoneList
        internalData: group.internalData
        costs: group.costs
    ).success (data, status, headers, config) ->
      $scope.auth()
      
  $scope.updatePaid = (group) ->
    $http.post("/updatePaid",
      secret: $scope.secret
      group:
        id: group._id
      costs: group.costs
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
  # Begin counters
  $scope.youngAdultNumber = 0
  $scope.youthNumber = 0
  $scope.chaperoneNumber = 0
  # Define an empty primary contact
  $scope.primaryContact =
    name: ""
    phone: ""
    email: ""
    extendedInfo:
      affiliation: ""
      address: ""
      city: ""
      province: ""
      postalCode: ""
      fax: ""
      
  # Make sure we're doing a new registration
  $scope.updateButton = false
  # Load Data if needed!
  if $routeParams.groupId
    $http.post("/getGroupId",
      id: $routeParams.groupId
    ).success (data, status, headers, config) ->
      console.log data
      # Set the lists up to load from data
      $scope.youthList = data.youthList
      $scope.chaperoneList = data.chaperoneList
      $scope.youngAdultList = data.youngAdultList
      # Begin counters
      $scope.youngAdultNumber = data.internalData.youngAdultNumber
      $scope.youthNumber = data.internalData.youthNumber
      $scope.chaperoneNumber = data.internalData.chaperoneNumber
      # Load up our Primary Contact
      $scope.primaryContact = data.primaryContact
      # Set something so we know to update, not newly register.
      $scope.updateButton = true
  
  # Define the submit button
  $scope.submit = ->
    if $scope.updateButton
      $http.post("/update",
        primaryContact: $scope.primaryContact
        youthList: $scope.youthList
        chaperoneList: $scope.chaperoneList
        youngAdultList: $scope.youngAdultList
        internalData: 
          youthNumber: $scope.youthNumber
          youngAdultNumber: $scope.youngAdultNumber
          chaperoneNumber: $scope.chaperoneNumber
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
        youthList: $scope.youthList
        chaperoneList: $scope.chaperoneList
        youngAdultList: $scope.youngAdultList
        internalData: 
          youthNumber: $scope.youthNumber
          youngAdultNumber: $scope.youngAdultNumber
          chaperoneNumber: $scope.chaperoneNumber
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
    $scope.youthNumber +=1
    $scope.youthList.push
      name: "Youth " + $scope.youthNumber
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
      number: $scope.youthNumber
  
  # Chaperone list
  $scope.addChaperone = ->
    $scope.chaperoneNumber += 1
    $scope.chaperoneList.push
      name: "Chaperone " + $scope.chaperoneNumber
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
      number: $scope.chaperoneNumber
  
  # Young Adult list
  $scope.addYoungAdult = ->
    $scope.youngAdultNumber += 1
    $scope.youngAdultList.push
      name: "Young Adult " + ($scope.youngAdultNumber)
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
      number: $scope.youngAdultNumber
  
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
# Home, does nothing yet.
###
@homeCtl = ($scope) ->

homeCtl.$inject = ["$scope"]

###
# Privacy, does nothing yet.
###
@privCtl = ($scope) ->

privCtl.$inject = ["$scope"]