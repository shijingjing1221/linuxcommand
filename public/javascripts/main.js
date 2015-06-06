var mainApp = angular.module("mainApp", ['ui.select']);
mainApp.controller("MainController", function($scope) {
    $scope.title = "Search commands";
    $scope.keyNames = [{
        id: 1,
        name: "NFS"
    }, {
        id: 2,
        name: "iSCSI"
    }];

    // $scope.KeyNames = ProductsApi.query({
    //     name_only: true
    // });
    $scope.keys = {};
    $scope.keys.loaded = {};
    $scope.removeKey = function(item) {
        _.remove($scope.keys.wanted, function(n) {
            return n.id === item.id;
        });
        // delete $scope.products.watned[item.id];
        delete $scope.keys.loaded[item.id];

    };

    $scope.addKey = function(item) {
        if (!$scope.keys.loaded[item.id]) {
            $scope.loading = true;
            $scope.keys.loaded[item.id] = {
                name:item.name,
                commands: [{
                    name: "yum install nfs"
                }, {
                    name: "systemctl restart nfsserver"
                }],
                files: [{
                    name: "/etc/nfsserver.conf"
                }, {
                    name: "/etc/exports"
                }]
            };
            // ProductsApi.get({
            //     id: item.id
            // }).$promise.then(function(data) {
            //     $scope.products.loaded[data.id] = data;
            //     data.versions.forEach(function(version, index) {
            //         if (version.eoldate > today) {
            //             version.show = true;
            //         }
            //     });
            //     $scope.loading = false;
            // });
        }
    };
});
// angular.bootstrap(document, ['mainApp']);