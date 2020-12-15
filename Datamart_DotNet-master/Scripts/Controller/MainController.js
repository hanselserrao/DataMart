(function () {
    'use strict';

    app.controller('mainCtrl', function ($scope, $http, $filter, $anchorScroll, $location, $compile, $mdDialog, $timeout, $q, appService, $window, cfpLoadingBar, $route, $templateCache) {
        appService.loadAuth();
        //var onFocus = function () {
        //    //appService.loadAuth();
        //    $scope.AuthValue = appService.loadAuthfromStrorage();
        //    $scope.$apply();
        //}

        $window.onfocus = function () {
            $scope.AuthValue = appService.loadAuthfromStrorage();
            if (!$scope.$$phase) {
                $scope.$apply();
            }
        };

        $scope.appServices = appService;
        $scope.AuthValue = {
            username: null,
            role: null,
            isAuth: false
        };

        if (appService.getAuth().isAuth) {
            //alert($location.path());
        } else {
            $scope.paramContext = '';
            if ($route.current) {
                $scope.paramContext = $route.current.$$route.paramContext;
                if (($scope.paramContext) == "ADM")
                    $location.path('/admin/login');
            } else {
                appService.setAuth({ username: 'Anonymous', role: 'Anonymous', isAuth: true });
                $location.path('/search');
            }
        }

        $scope.$watch("appServices.getAuth()", function (newValue, oldValue) {
            if (newValue != oldValue) {
                $scope.AuthValue = newValue;
                console.log($scope.AuthValue);
            }
        });
        $scope.AuthValue = appService.getAuth();

        $scope.logout = function () {
            appService.removeAuth();
            appService.setAuth({ username: 'Anonymous', role: 'Anonymous', isAuth: true });
            if ($route.current) {
                $scope.paramContext = $route.current.$$route.paramContext;
                if (($scope.paramContext) == "ADM")
                    $location.path('/admin/login');
                //window.location.reload();
            } else {
                $location.path('/search');
            }

            //$http.get('home/Logout').then(function () {
            //    window.location.reload();
            //});
        }

    });


})();
