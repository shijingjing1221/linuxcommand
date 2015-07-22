var mainApp = angular.module("mainApp", ['ui.select', 'ngResource', 'ngClipboard', 'ui.bootstrap']);


mainApp.factory("KeywordsApi", function($resource) {
    return $resource('/api' + '/keywords/:id', {
        id: '@id'
    }, {});
});

mainApp.filter('unsafe', ['$sce', function ($sce) {
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

mainApp.controller("MainController", function($scope, KeywordsApi) {
    $scope.loadingContent = "Loading the keywords from server...";
    $scope.loading = true;
    $scope.title = "Linux command search ";

    $scope.keywordNames = KeywordsApi.query({
        name_only: true
    }, function(data) {
        $scope.loading = false;
    });

    $scope.keywords = {};
    $scope.keywords.loaded = {};

    $scope.removeKeyword = function(item) {
        $scope.keywords.wanted = _.filter($scope.keywords.wanted, function(keyword) {
            return keyword.id != item.id;
        });
        delete $scope.keywords.loaded[item.id];

    };

    $scope.addKeyword = function(item) {
        if (!$scope.keywords.loaded[item.id]) {
            $scope.loadingContent = "Loading the commands from server...";
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