var adminApp = angular.module("adminApp", ['ui.select', 'ngResource', 'ngClipboard', 'ui.bootstrap']);


adminApp.factory("KeywordsApi", function($resource) {
    return $resource('/api' + '/keywords/:id', {
        id: '@id'
    }, {});
});

adminApp.factory("ResourcesApi", function($resource) {
    return $resource('/api' + '/keywords/:id' + '/resources/:resourceType', {
        id: '@id',
        resourceType: '@resourceType'
    }, {
        CreateNewResource: {
            method: "POST",
            data: {
                name: ""
            }
        }
    });
});


adminApp.controller("AdminController", function($scope, KeywordsApi, ResourcesApi) {
    $scope.title = "Select a keyword to edit";

    $scope.keywordNames = KeywordsApi.query({
        name_only: true
    });
    $scope.keyword = {};
    $scope.keyword.selected = undefined;
    $scope.currentContent = undefined;
    $scope.newFile = null;

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
        var files = $scope.currentContent.files;
        var newFile = $scope.newFile;
        var result = _.find(files, _.matchesProperty('name', newFile));
        if (result != undefined) {
            $scope.newFile = null;
            return;
        }
        files.push({
            id: null,
            name: newFile
        });
        $scope.newFile = null;
        ResourcesApi.CreateNewResource({
            id: $scope.keyword.selected.id,
            resourceType: "file",
            name: newFile
        }).$promise.then(function(data) {
            $scope.currentContent = data;
        });
    };

    $scope.addNewCommand = function() {
        var commands = $scope.currentContent.commands;
        var newCommand = $scope.newCommand;
        var result = _.find(commands, _.matchesProperty('name', newCommand));
        if (result != undefined) {
            $scope.newCommand = null;
            return;
        }
        commands.push({
            id: null,
            name: newCommand
        });
        $scope.newCommand = null;
        ResourcesApi.CreateNewResource({
            id: $scope.keyword.selected.id,
            resourceType: "command",
            name: newCommand
        }).$promise.then(function(data) {
            $scope.currentContent = data;
        });

    };


});