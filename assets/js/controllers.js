'use strict';

/* Controllers */

/* Managment Controller. This handles the database viewer.
 *
 */
function manCtl($scope, $http) {
	$scope.attendees = $http.get('/attendees');
};


/* Register Controller. This handles the entire registration form.
 * It may be wise to find a cleaner format for this.
 */
function regCtl($scope, $http, $anchorScroll) {
	$scope.submit = function (){
		$http.post('/register', 
				{ 
					Name 		: $scope.Name,
					Address : $scope.Address,
					Location: $scope.Location,
					Phone		:	$scope.Phone,
					Email		:	$scope.Email
				});
	};
	$scope.scrollto = function goToByScroll(id){
		$anchorScroll(id);
	};
};
regCtl.$inject = ['$scope','$http', '$anchorScroll'];

/* Home controller. Does nothing, yet.
 *
 */
function homeCtl() {};
homeCtl.$inject = [];
