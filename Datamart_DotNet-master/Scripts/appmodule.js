var app;

(function () {
    'use strict';
    app = angular.module("app", ['ngRoute', 'ngMaterial', 'angularUtils.directives.dirPagination', 'autocomplete', 'chieffancypants.loadingBar', 'ngSanitize']);
    app.config(function ($mdDateLocaleProvider) {

        $mdDateLocaleProvider.formatDate = function (date) {
            return moment(date).format('DD-MM-YYYY');
        };

    });
    app.config(['$routeProvider',function ($routeProvider) {
        $routeProvider
            .when("/", {
                title: 'Landing Page',
                //templateUrl: "tiles.html"
                templateUrl: "tiles.html",
                controller: 'homeIndexCtrl'
            })
            .when("/partsearch", {
                title: 'Part Search',
                templateUrl: "partsearch.html",
                controller: 'homeIndexCtrl'
            })
            .when("/datamartSearch", {
                title: 'Datamart Search Result',
                templateUrl: "datamartSearch.html",
                controller: 'homeIndexCtrl'

            })
            .when("/search", {
                title: 'Main Search',
                templateUrl: "tiles.html",
                controller: 'homeIndexCtrl'

            })
            .when("/docsearch", {
                title: 'Document Search',
                templateUrl: "docsearch.html",
                controller: 'homeIndexCtrl'

            })
            .when("/pcnsearch", {
                title: 'PCN Search',
                templateUrl: "pcnsearch.html",
                controller: 'homeIndexCtrl'
            })
            .when("/etosearch", {
                templateUrl: "etosearch.html",
                title: 'ETO Search',
                controller: 'homeIndexCtrl'
            })
            .when("/ledsearch", {
                title: 'LED Search',
                templateUrl: "ledsearch.html",
                controller: 'homeIndexCtrl'
            })
            .when("/login", {
                title: 'Login',
                templateUrl: "login.html",
                paramContext: 'APP',
                controller: 'loginCtrl'
            })
            .when("/admin/login", {
                title: 'Login',
                templateUrl: "login.html",
                paramContext:'ADM',
                controller: 'loginCtrl'
            })
            .when("/admin", {
                title: 'Login',
                templateUrl: "login.html",
                paramContext: 'ADM',
                controller: 'loginCtrl'
            })
            .when("/admin/index", {
                title: 'User Search',
                templateUrl: "admin/index.html",
                paramContext: 'ADM',
                controller: 'adminIndexCtrl',
            })
            .when("/admin/adduser", {
                title: 'Add New User',
                templateUrl: "admin/AddUser.html",
                paramContext: 'ADM',
                controller: 'adminIndexCtrl',
            })
            .when("/AMR/index", {
                title: 'AMR Search',
                templateUrl: "AMR/index.html",
                paramContext: 'AMR',
                controller: 'AMRIndexCtrl',
            })
            .when("/AMR/CreateProblemReport", {
                title: 'Create AMR',
                templateUrl: "AMR/CreateProblemReport.html",
                paramContext: 'AMR',
                controller: 'AMRIndexCtrl',
            })
    }]);

    app.filter('unique', function () {
        // we will return a function which will take in a collection
        // and a keyname
        return function (collection, keyname) {
            debugger
            // we define our output and keys array;
            var output = [],
                keys = [];

            // we utilize angular's foreach function
            // this takes in our original collection and an iterator function
            angular.forEach(collection, function (item) {
                // we check to see whether our object exists
                var key = item[keyname];
                // if it's not already part of our keys array
                if (keys.indexOf(key) === -1) {
                    // add it to our keys array
                    keys.push(key);
                    // push this item to our final output array
                    output.push(item);
                }
            });
            // return our array which should be devoid of
            // any duplicates
            return output;
        };
    });

    app.filter('split', function () {
        return function (input, splitChar, splitIndex) {
            // do some bounds checking here to ensure it has that index
            if (input) {
                var data = input.split(splitChar);
                return data;
            } else
                return 0;
        }
    });
})();
