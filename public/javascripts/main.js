var mainApp = angular.module("mainApp", ['ui.select','ngResource']);
mainApp.factory("KeysApi", function ($resource) {
    return $resource('/api' + '/keys/:id', { id: '@id' }, {});
});
mainApp.controller("MainController", function($scope, KeysApi) {
    $scope.title = "Search commands";
    $scope.keyNames = [{
        id: 1,
        name: "iSCSI"
    }];

    // $scope.KeyNames = KeysApi.query({
    //     name_only: true
    // });
    $scope.keys = {};
    $scope.keys.loaded = {};
    $scope.removeKey = function(item) {
        _.remove($scope.keys.wanted, function(n) {
            return n.id === item.id;
        });
        delete $scope.keys.loaded[item.id];

    };

    $scope.addKey = function(item) {
        if (!$scope.keys.loaded[item.id]) {
            $scope.loading = true;
            // $scope.keys.loaded[item.id] = {
            //     name:item.name,
            //     commands: [{
            //         name: "yum install nfs"
            //     }, {
            //         name: "systemctl restart nfsserver"
            //     }],
            //     files: [{
            //         name: "/etc/nfsserver.conf"
            //     }, {
            //         name: "/etc/exports"
            //     }]
            // };
            KeysApi.get({
                id: item.id
            }).$promise.then(function(data) {
                $scope.keys.loaded[data.id] = data;
                $scope.loading = false;
            });
        }
    };
});