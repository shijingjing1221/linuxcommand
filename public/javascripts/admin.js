var adminApp = angular.module("adminApp", ['ui.select', 'ngResource', 'ngClipboard', 'ui.bootstrap']);


adminApp.factory("KeywordsApi", function($resource) {
    return $resource('/api' + '/keywords/:id', {
        id: '@id'
    }, {});
});

adminApp.controller("AdminController", function($scope, KeywordsApi) {
    $scope.title = "Select a keyword to edit";

    $scope.keywordNames = KeywordsApi.query({
        name_only: true
    });
    $scope.keyword = {};
    $scope.keyword.selected = undefined;
    $scope.currentContent = undefined;

    $scope.$watch('keyword.selected', function(item) {
        KeywordsApi.get({
            id: item.id
        }).$promise.then(function(data) {
            $scope.currentContent = data;
        });
    });



});