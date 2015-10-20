var adminApp = angular.module("adminApp", ['ui.select', 'ngResource', 'ngClipboard', 'ui.bootstrap', 'ui.bootstrap.modal']);


adminApp.factory("KeywordsApi", function ($resource) {
    return $resource('/api' + '/keywords/:id', {
        id: '@id'
    }, {
        CreateNewKeyword: {
            method: "POST",
            data: {
                name: ""
            }
        }
    });
});

adminApp.factory("ResourcesApi", function ($resource) {
    return $resource('/api' + '/keywords/:id' + '/resources/:resourceType', {
        id: '@id',
        resourceType: '@resourceType'
    }, {
        CreateNewResource: {
            method: "POST",
            data: {
                name: "",
                note: ""
            }
        }
    });
});

adminApp.factory("ResourceApi", function ($resource) {
    return $resource('/api' + '/resource/:resourceId', {
        resourceId: '@resourceId'
    }, {
        UpdateResource: {
            method: "put",
            data: {
                name: "",
                note: ""
            }
        }
    });
});

adminApp.filter('unsafe', ['$sce', function ($sce) {
    return function (val) {
        return $sce.trustAsHtml(val);
    };
}]);
// update popover template for binding unsafe html
angular.module("template/popover/popover.html", []).run(["$templateCache", function ($templateCache) {
    $templateCache.put("template/popover/popover.html",
        "<div class=\"popover {{placement}}\" ng-class=\"{ in: isOpen(), fade: animation() }\">\n" +
        "  <div class=\"arrow\"></div>\n" +
        "\n" +
        "  <div class=\"popover-inner\">\n" +
        "      <h3 class=\"popover-title\" ng-bind-html=\"title | unsafe\" ng-show=\"title\"></h3>\n" +
        "      <div class=\"popover-content\"ng-bind-html=\"content | unsafe\"></div>\n" +
        "  </div>\n" +
        "</div>\n" +
        "");
}]);

adminApp.controller("AdminController", function ($scope, $modal, $log, KeywordsApi, ResourcesApi, ResourceApi) {
    $scope.loadingContent = "Loading the keywords from server...";
    $scope.loading = true;
    $scope.title = "Linux Command";

    $scope.titleForEdit = "Select a keyword to edit";
    $scope.titleForCreate = "Input a keyword to create";
    $scope.selectPlaceHolder = "Select a keyword to edit";

    $scope.keywordNames = KeywordsApi.query({
        name_only: true
    }, function (data) {
        $scope.loading = false;
    });
    $scope.keyword = {};
    $scope.keyword.selected = undefined;
    $scope.currentContent = undefined;
    $scope.newFile = null;

    $scope.$watch('keyword.selected', function (item) {
        if (item == null || item.id == null)
            return;
        KeywordsApi.get({
            id: item.id
        }).$promise.then(function (data) {
            $scope.currentContent = data;
        });
    });

    $scope.addNewFile = function () {
        var files = $scope.currentContent.files;
        var newFile = $scope.newFile;
        var newFileNote = $scope.newFileNote;
        var result = _.find(files, _.matchesProperty('name', newFile));
        if (result != undefined) {
            $scope.newFile = null;
            $scope.newFileNote = null;
            return;
        }
        files.push({
            id: null,
            name: newFile,
            note: newFileNote
        });
        $scope.newFile = null;
        $scope.newFileNote = null;
        ResourcesApi.CreateNewResource({
            id: $scope.keyword.selected.id,
            resourceType: "file",
            name: newFile,
            note: newFileNote
        }).$promise.then(function (data) {
            $scope.currentContent = data;
        });
    };

    $scope.addNewCommand = function () {
        var commands = $scope.currentContent.commands;
        var newCommand = $scope.newCommand;
        var newCommandNote = $scope.newCommandNote;
        var result = _.find(commands, _.matchesProperty('name', newCommand));
        if (result != undefined) {
            $scope.newCommand = null;
            $scope.newCommandNote = null;
            return;
        }
        commands.push({
            id: null,
            name: newCommand,
            note: newCommandNote
        });
        $scope.newCommand = null;
        $scope.newCommandNote = null;
        ResourcesApi.CreateNewResource({
            id: $scope.keyword.selected.id,
            resourceType: "command",
            name: newCommand,
            note: newCommandNote
        }).$promise.then(function (data) {
            $scope.currentContent = data;
        });

    };

    $scope.addNewKeyword = function () {
        var newKeyword = $scope.newKeyword;
        var keywords = $scope.keywordNames;
        var result = _.find(keywords, _.matchesProperty('name', newKeyword));
        if (result != undefined) {
            $scope.newKeyword = null;
            alert("This keyword is existed!");
            return;
        }
        var keywordObj = {
            id: null,
            name: newKeyword
        };
        keywords.push(keywordObj);
        $scope.keyword.selected = keywordObj;
        $scope.creating = false;

        KeywordsApi.CreateNewKeyword({
            name: newKeyword
        }).$promise.then(function (data) {
            keywordObj.id = data.id;
            $scope.currentContent = data;
        });
    };
    $scope.openEditor = function (selectedItem) {

        var modalInstance = $modal.open({
            animation: $scope.animationsEnabled,
            templateUrl: 'myModalContent.html',
            controller: 'ModalInstanceCtrl',
            resolve: {
                selectedItem: function () {
                    return selectedItem;
                }
            }
        });

        modalInstance.result.then(function (item) {
            $scope.item = item;
            ResourceApi.UpdateResource({
                resourceId: item.id,
                name: item.name,
                note: item.note
            }).$promise.then(function (data) {
                $scope.item.name = item.name;
                $scope.item.note = item.note;
            })
        }, function () {
            $log.info('Modal dismissed at: ' + new Date());
        });
    };

});

adminApp.controller('ModalInstanceCtrl', function ($scope, $modalInstance, selectedItem) {

    $scope.item = selectedItem;

    $scope.ok = function () {
        $modalInstance.close($scope.item);
    };

    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    };
});