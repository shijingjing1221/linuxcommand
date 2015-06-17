var mainApp = angular.module("mainApp", ['ui.select','ngResource']);
mainApp.factory("KeywordsApi", function ($resource) {
    return $resource('/api' + '/keywords/:id', { id: '@id' }, {});
});
mainApp.controller("MainController", function($scope, KeywordsApi) {
    $scope.title = "Command search ";

    $scope.keywordNames = KeywordsApi.query({
        name_only: true
    });
    $scope.keywords = {};
    $scope.keywords.loaded = {};
    $scope.removeKeyword = function(item) {
        _.remove($scope.keywords.wanted, function(n) {
            return n.id === item.id;
        });
        delete $scope.keywords.loaded[item.id];

    };

    $scope.addKeyword = function(item) {
        if (!$scope.keywords.loaded[item.id]) {
            $scope.loading = true;

            KeywordsApi.get({
                id: item.id
            }).$promise.then(function(data) {
                $scope.keywords.loaded[data.id] = data;
                $scope.loading = false;
            });
        }
    };
});