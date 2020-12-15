(function () {
    'use strict';


    app.service('appService', function ($http,$q) {
        var AuthValue = {
            username: null,
            role: null,
            isAuth: false,
            etllastupdate:'Not Available'
        }
        var routeModel = {
            paramContext: '',
            loginType: ''
        };

        this.uploadFileToUrl = function (file, uploadUrl) {
            var fd = new FormData();
            fd.append('file', file);

            $http.post(uploadUrl, fd, {
                transformRequest: angular.identity,
                headers: { 'Content-Type': undefined }
            })
            .success(function () {
            })

            .error(function () {
            });
        }

        this.VerifySession = function () {
            /*
            var data = "";
            var deferred = $q.defer();

            $http.get('Home/VerifySession')
                    .success(function (response, status, headers, config) {
                        deferred.resolve(response);
                        return response.SessionExist;
                    })
                    .error(function (errResp) {
                        deferred.reject({ message: "Really bad" });
                    });
            return deferred.promise;

            */
            $http({
                method: 'get',
                url: 'Home/VerifySession',
                ContentType: 'json',
                })
                .then(function (data, status, headers, config) {
                    return data.data;
                }
            )
        };

        this.loadAuth = function () {
            
            var xhReq = new XMLHttpRequest();
            xhReq.open("GET", 'Home/VerifySession', false);
            xhReq.send(null);
            var data = JSON.parse(xhReq.response);
            localStorage.setItem('etllastupdate', data.etlLastUpdate)
            if (!data.SessionExist) {
                //this.removeauth();
                localStorage.setItem('username', 'Anonymous');
                localStorage.setItem('role', 'Anonymous');
                localStorage.setItem('isAuth', true);
            }
            return this.loadAuthfromStrorage();
        };

        this.loadAuthfromStrorage = function () {
            var username = localStorage.getItem('username');
            var role = localStorage.getItem('role');
            var isAuth = localStorage.getItem('isAuth') == 'true' ? true : false;
            var etllastupdate = localStorage.getItem('etllastupdate');
            AuthValue = { username: username, role: role, isAuth: isAuth, etllastupdate:etllastupdate};
            return AuthValue;
        };


        this.getAuth = function () {
            return AuthValue;
        };

        this.setAuth = function (value) {
            localStorage.setItem('username', value.username);
            localStorage.setItem('role', value.role);
            localStorage.setItem('isAuth', value.isAuth);
            this.loadAuth();
        };

        this.removeAuth = function () {
            localStorage.removeItem('username');
            localStorage.removeItem('role');
            localStorage.removeItem('isAuth');
            AuthValue.username = null;
            AuthValue.role = null;
            AuthValue.isAuth = null;
        };

        this.setRouteModel = function (paramContext, loginType) {
            routeModel.paramContext = paramContext;
            routeModel.loginType = loginType;
        };

        this.getRouteModel = function () {
            return routeModel;
        };

    });

    app.directive('fileModel', ['$parse', function ($parse) {
        return {
            restrict: 'A',
            link: function (scope, element, attrs) {
                var model = $parse(attrs.fileModel);
                var modelSetter = model.assign;

                element.bind('change', function () {
                    scope.$apply(function () {
                        modelSetter(scope, element[0].files[0]);
                    });
                });
            }
        };
    }]);

    app.factory('MovieRetriever', ['$http', '$q', '$timeout', function ($http, $q, $timeout) {
        var moreMovies;
        var MovieRetriever = new Object();
        MovieRetriever.getPcnNumber = function (i) {
            var moviedata = $q.defer();
            var movies;
            $http({
                method: 'Get',
                url: 'Home/GetPcnnumber?prefix=' + i,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    moreMovies = data1.data;
                });
            if (i && i.indexOf('T') != -1)
                movies = moreMovies;
            else
                movies = moreMovies;

            $timeout(function () {
                moviedata.resolve(movies);
            }, 1000);

            return moviedata.promise
        } 
        MovieRetriever.getEtoNumber = function (i) {
            var moviedata = $q.defer();
            var movies;
            $http({
                method: 'Get',
                url: 'Home/GetEtonumber?prefix=' + i,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    moreMovies = data1.data;

                });
            if (i && i.indexOf('T') != -1)
                movies = moreMovies;
            else
                movies = moreMovies;

            $timeout(function () {
                moviedata.resolve(movies);
            }, 1000);

            return moviedata.promise
        }
        MovieRetriever.getLEDNumber = function (i) {
            var moviedata = $q.defer();
            var movies;
            $http({
                method: 'Get',
                url: 'Home/GetLednumber?prefix=' + i,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    moreMovies = data1.data;

                });
            if (i && i.indexOf('T') != -1)
                movies = moreMovies;
            else
                movies = moreMovies;

            $timeout(function () {
                moviedata.resolve(movies);
            }, 1000);

            return moviedata.promise
        }
        MovieRetriever.getdocNumber = function (i) {

            var moviedata = $q.defer();
            var movies;
            $http({
                method: 'Get',
                url: 'Home/GetDocnumber?prefix=' + i,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    moreMovies = data1.data;

                });
            if (i && i.indexOf('T') != -1)
                movies = moreMovies;
            else
                movies = moreMovies;

            $timeout(function () {
                moviedata.resolve(movies);
            }, 1000);

            return moviedata.promise
        }
        MovieRetriever.getmovies = function (i) {
            var moviedata = $q.defer();
            var movies;
            $http({
                method: 'Get',
                url: 'Home/GetPartnumber?prefix=' + i,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    moreMovies = data1.data;

                })

            if (i && i.indexOf('T') != -1)
                movies = moreMovies;
            else
                movies = moreMovies;

            $timeout(function () {
                moviedata.resolve(movies);
            }, 1000);

            return moviedata.promise
        }

        return MovieRetriever;
    }]);

    // change Page Title based on the routers
    app.run(['$location', '$rootScope', function ($location, $rootScope) {
        $rootScope.$on('$routeChangeSuccess', function (event, current, previous) {
            $rootScope.title = current.$$route.title;
            //alert($rootScope.title);
        });
    }]);
})();

