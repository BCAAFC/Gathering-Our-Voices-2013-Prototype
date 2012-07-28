'use strict';

/* Controllers */
function regCtl($scope, $http) {
	$scope.submit = function (){
		$http.post('/register', { Name: $scope.Name });
	}
};
regCtl.$inject = ['$scope','$http'];


function homeCtl() {};
homeCtl.$inject = [];
