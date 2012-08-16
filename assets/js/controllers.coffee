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
  $scope.submit = ->
    $http.post "/register",
      primaryContact: $scope.primaryContact
      youthList: $scope.youthList
      chaperoneList: $scope.chaperoneList
      youngAdultList: $scope.youngAdultList
    console.log($scope.submitButton)

  $scope.primaryContact =
    name: ""
    status: ""
    gender: ""
    birthDate: ""
    phone: ""
    email: ""
    extendedInfo:
      affiliation: ""
      address: ""
      city: ""
      province: ""
      postalCode: ""
      fax: ""
    emergencyInfo:
      name: ""
      relation: ""
      phone: ""
      medicalNum: ""
      allergies: ""
      illnesses: ""
  
  # Youth list
  $scope.youthList = []
  $scope.addYouth = ->
    $scope.youthList.push
      name: "Youth " + ($scope.youthList.length + 1)
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
      number: ($scope.youthList.length + 1)
  
  # Chaperone list
  $scope.chaperoneList = []
  $scope.addChaperone = ->
    $scope.chaperoneList.push
      name: "Chaperone " + ($scope.chaperoneList.length + 1)
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
      number: ($scope.chaperoneList.length + 1)
  
  # Young Adult list
  $scope.youngAdultList = []
  $scope.addYoungAdult = ->
    $scope.youngAdultList.push
      name: "Young Adult " + ($scope.youngAdultList.length + 1)
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
      number: ($scope.youngAdultList.length + 1)

regCtl.$inject = ["$scope", "$http", "$anchorScroll", "$location"]

###
# Home, does nothing yet.
###
@homeCtl = ->

homeCtl.$inject = []
