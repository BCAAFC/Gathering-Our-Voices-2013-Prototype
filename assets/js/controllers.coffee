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
@regCtl = ($scope, $http, $anchorScroll) ->
  $scope.submit = ->
    console.log $scope.youthList
    $http.post "/register",
      primaryContact: $scope.primaryContact
      youthList: $scope.youthList
      chaperoneList: $scope.chaperoneList
      youngAdultList: $scope.youngAdultList


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
      status: ""
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
      status: ""
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
      status: ""
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

regCtl.$inject = ["$scope", "$http", "$anchorScroll"]

###
# Home, does nothing yet.
###
@homeCtl = ->

homeCtl.$inject = []
