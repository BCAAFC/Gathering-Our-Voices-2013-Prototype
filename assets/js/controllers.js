'use strict';

/* Controllers */

/* Managment Controller. This handles the database viewer.
 *
 */
function manCtl($scope, $http) {
	$scope.attendees = $http.get('/attendees');
};

/**
 * Login Controller. Handles logins, so it's sort of a big deal.
 */
function loginCtl($scope, $http) {
	$scope.login = function (){
		$http.post('/login',
				{
					username : $scope.username,
					password : $scope.password
				});
	};
};
	

/* Register Controller. This handles the entire registration form.
 * It may be wise to find a cleaner format for this.
 */
function regCtl($scope, $http, $anchorScroll) {
	$scope.submit = function (){
		$http.post('/register', 
				{ 
					name 		: $scope.name,
					password: $scope.password,
					address : $scope.address,
					city		: $scope.city,
					phone		:	$scope.phone,
					email		:	$scope.email
				});
	};
	$scope.scrollto = function goToByScroll(id){
		$anchorScroll(id);
	};
};
regCtl.$inject = ['$scope','$http', '$anchorScroll'];

/**
 * Home, does nothing yet.
 */
function homeCtl() {};
homeCtl.$inject = [];
