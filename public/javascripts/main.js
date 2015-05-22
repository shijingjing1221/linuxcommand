var mainApp = angular.module("mainApp", []);
mainApp.controller("MainController",MainController);
function MainController($scope){
$scope.title = "Demo";
}