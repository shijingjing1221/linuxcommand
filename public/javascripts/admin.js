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
    $scope.newfile = null;

    $scope.$watch('keyword.selected', function(item) {
        if (item == null || item.id == null)
            return;
        KeywordsApi.get({
            id: item.id
        }).$promise.then(function(data) {
            $scope.currentContent = data;
        });
    });

    $scope.addNewFile = function() {
        $scope.currentContent.files.push({
            id: null,
            name: $scope.newfile
        });
        $scope.newfile = null;
    };

    $scope.addNewCommand = function() {
        $scope.currentContent.commands.push({
            id: null,
            name: $scope.newCommand
        });
        $scope.newCommand = null;
    };


});