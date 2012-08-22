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
@regCtl = ($scope, $http, $anchorScroll, $location) ->
  $scope.youngAdultNumber = 0
  $scope.youthNumber = 0
  $scope.chaperoneNumber = 0
  
  $scope.submit = ->
    $scope.submitted = true
    $http.post "/register",
      primaryContact: $scope.primaryContact
      youthList: $scope.youthList
      chaperoneList: $scope.chaperoneList
      youngAdultList: $scope.youngAdultList
      costs:
        paidTickets: $scope.paidTickets()
        freeTickets: $scope.freeTickets()
        paid: 0

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
  
  # Youth list
  $scope.youthList = []
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
  $scope.chaperoneList = []
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
  $scope.youngAdultList = []
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

regCtl.$inject = ["$scope", "$http", "$anchorScroll", "$location"]

###
# Home, does nothing yet.
###
@homeCtl = ->

homeCtl.$inject = []
