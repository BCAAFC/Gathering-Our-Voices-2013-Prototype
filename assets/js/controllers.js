'use strict';

/* Controllers */
function regCtl($scope, $http, $anchorScroll) {
	$scope.submit = function (){
		$http.post('/register', 
				{ 
					primaryName 		: $scope.primaryName,
					primaryAddress 	: $scope.primaryAddress,
					primaryLocation : $scope.primaryLocation,
					primaryPhone		:	$scope.primaryPhone,
					primaryEmail		:	$scope.primaryEmail
				});
	};
	$scope.scrollto = function goToByScroll(id){
		$anchorScroll(id);
	};
};
regCtl.$inject = ['$scope','$http', '$anchorScroll'];


function homeCtl() {};
homeCtl.$inject = [];
