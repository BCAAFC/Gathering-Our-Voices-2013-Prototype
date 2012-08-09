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
	
	$scope.primaryContact = {
		name			: '',
		status		: '',
		gender		: '',
		birthDate	: '',
		phone			:	'',
		email			: '',
		extendedInfo :
			{
				affiliation	: '',
				address			:	'',
				city				:	'',
				province		:	'',
				postalCode	:	'',
				fax					:	''
			},
		emergencyInfo	:
			{
				name			:	'',
				relation	: '',
				phone			: '',
				medicalNum: '',
				allergies	:	''
			}
	};

	// Youth list
	$scope.youthList = [];
	$scope.addYouth = function (){
		$scope.youthList.push({name: 'Youth ' + ($scope.youthList.length+1), number: ($scope.youthList.length+1) });
	};
	
	// Chaperone list
	$scope.chaperoneList = [];
	$scope.addChaperone = function (){
		$scope.chaperoneList.push({name: 'Chaperone ' + ($scope.chaperoneList.length+1), number: ($scope.chaperoneList.length+1) });
	};
	
	// Young Adult list
	$scope.youngAdultList = [];
	$scope.addYoungAdult = function (){
		$scope.youngAdultList.push({name: 'Young Adult ' + ($scope.youngAdultList.length+1), number: ($scope.youngAdultList.length+1) });
	};

};
regCtl.$inject = ['$scope','$http', '$anchorScroll'];

/**
 * Home, does nothing yet.
 */
function homeCtl() {};
homeCtl.$inject = [];
