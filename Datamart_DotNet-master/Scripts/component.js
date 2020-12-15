//'use strict';
//        angular.module("app",[])
//            .controller('ctrl', function ($scope, $http, $filter) {

//            });
//"use strict"
//app.config(['$qProvider', function ($qProvider) {
//    $qProvider.errorOnUnhandledRejections(false);
//}])
function functionToRunWhenReady(id) {
    angular.element(document).ready(function () {
        var scope = angular.element($('#input_2')).scope();
        scope.$apply(function () {
            scope.documentNumber = id;
            localStorage.setItem('docnumber', id);
            var readyStateCheckInterval = setInterval(function () {
                if (document.readyState === "complete") {
                    clearInterval(readyStateCheckInterval);
                    angular.element('.dcobtn').triggerHandler('click');
                }
            }, 10);
        });
    });
}

(function () {
    'use strict';

    var app = angular.module("app", ['ngRoute', 'ngMaterial', 'angularUtils.directives.dirPagination', 'autocomplete', 'chieffancypants.loadingBar']);
    app.config(function ($routeProvider) {
        $routeProvider
            .when("/", {
                title: 'Landing Page',
                //templateUrl: "tiles.html"
                templateUrl: "tiles.html"
            })
            .when("/partsearch", {
                title: 'Part Search',
                templateUrl: "partsearch.html",
                controller: 'ctrl'

            })
            .when("/search", {
                title: 'Main Search',
                templateUrl: "tiles.html"

            })
            .when("/docsearch", {
                title: 'Document Search',
                templateUrl: "docsearch.html"

            })
            .when("/pcnsearch", {
                title: 'PCN Search',
                templateUrl: "pcnsearch.html"
            })
            .when("/etosearch", {
                templateUrl: "etosearch.html",
                title: 'ETO Search'
            })
            .when("/ledsearch", {
                title: 'LED Search',
                templateUrl: "ledsearch.html"
            })
            .when("/login", {
                title: 'Login',
                templateUrl: "login.html"

            })
    });
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
            //alert(current.$$route.title);
            $rootScope.title = current.$$route.title;
            //alert($rootScope.title);
        });
    }]);



    app.controller('ctrl', function ($scope, $http, $filter, $anchorScroll, $location, $compile, $mdDialog, $timeout, $q, MovieRetriever, $window, cfpLoadingBar, $route, $templateCache) {
        $scope.start = function () {
            cfpLoadingBar.start();
            alert("main");
        };

        $scope.complete = function () {
            cfpLoadingBar.complete();
        }

        $scope.login = function () {
            $scope.email = 'admin@admin.com'
            $scope.password = 'password';
            alert("inside login");
            var data = { email: $scope.email, password: $scope.password };
            if ($scope.rememberme) {

                localStorage.setItem('email', $scope.email);
                localStorage.setItem('password', $scope.password);
            } else {
                localStorage.removeItem('email');
                localStorage.removeItem('password');
            }

            $http({
                method: 'get',
                url: 'Home/Login1?email=' + $scope.email + '&password=' + $scope.password,
                ContentType: 'json',
            })
                .then(function (data, status, headers, config) {

                    if (data.data.mode == 1) {
                        console.log(data);
                        $location.path('/search');
                        $scope.errordiv = false;
                        localStorage.setItem('username', data.data.username)
                        $scope.username = true;
                        $scope.user = data.data.username
                        console.log(localStorage.getItem('username'));
                        setTimeout(function () {
                            window.location.reload();
                        }, 500)


                    }
                    if (data.data.mode == 2) {
                        $scope.errordiv = true;
                        $scope.errormsg = "invalid login attempt"
                    }
                    //$scope.pcndetail = data.data;
                    // 
                    //$scope.pcdatalist[index].pcndetail = $scope.pcndetail;
                    //$scope.pcdatalist = $scope.pcdatalist;
                    //console.log($scope.pcdatalist)
                },
                    function (error) {
                        console.log(error)
                    }
                )
        };

        //alert("0");
        var sess = localStorage.getItem('username')

        if (sess == null || sess == undefined) {
            localStorage.setItem('username', 'Anonymous')
        }

        sess = localStorage.getItem('username')
        var remmer = localStorage.getItem('email')
        
        alert(sess);
        if (remmer) {
            alert("1");
            $scope.email = localStorage.getItem('email');
            $scope.password = localStorage.getItem('password');
            $scope.rememberme = true;
        }
        if (sess != null && sess != undefined) {
            var url = $location.path();
            $scope.isAuth = true;
            $scope.username = true;
            $scope.user = sess;
            //alert(url);
            if (url == '/search') {
                $location.path('/search');

            }
            else if (url == '/docsearch')
                $location.path('/docsearch');
            else if (url == '/pcnsearch')
                $location.path('/pcnsearch');
            else if (url == '/partsearch')
                $location.path('/partsearch');
            else if (url == '/etosearch')
                $location.path('/etosearch');
            else if (url == '/ledsearch')
                $location.path('/ledsearch');
            else if (url == '/login')
                $location.path('/login');
            else
                $location.path('/search');
        }

        $scope.fnDownLoad = function (file, datasetname) {

            $scope.FileExt = file.replace(/^.*\./, '');/*file.name.substr(file.name.length - 4)*/
            $scope.GenerateFileType($scope.FileExt);
            $scope.RenderFile(file, datasetname);
        }

        $scope.RenderFile = function (file, datasetname) {
            var s = "Home/DownLoadFile?"
                + "FileName=" + file
                + "&fileType=" + $scope.FileType + "&datasetName=" + datasetname;
            $window.open(s);
        }



        $scope.GenerateFileType = function (fileExtension) {
            switch (fileExtension.toLowerCase()) {
                case "doc":
                case "docx":
                    $scope.FileType = "application/msword";
                    break;
                case "xls":
                case "xlsx":
                    $scope.FileType = "application/vnd.ms-excel";
                    break;
                case "pps":
                case "ppt":
                    $scope.FileType = "application/vnd.ms-powerpoint";
                    break;
                case "txt":
                    $scope.FileType = "text/plain";
                    break;
                case "rtf":
                    $scope.FileType = "application/rtf";
                    break;
                case "pdf":
                    $scope.FileType = "application/pdf";
                    break;
                case "msg":
                case "eml":
                    $scope.FileType = "application/vnd.ms-outlook";
                    break;
                case "gif":
                case "bmp":
                case "png":
                case "jpg":
                    $scope.FileType = "image/JPEG";
                    break;
                case "dwg":
                    $scope.FileType = "application/acad";
                    break;
                case "zip":
                    $scope.FileType = "application/x-zip-compressed";
                    break;
                case "rar":
                    $scope.FileType = "application/x-rar-compressed";
                    break;
            }
        }

        $scope.setFiles = function (element) {
            $scope.$apply(function (scope) {
                $scope.AttachStatus = "";
                $scope.files = []
                for (var i = 0; i < element.files.length; i++) {
                    $scope.files.push(element.files[i])
                }
                $scope.progressVisible = false
            });
        }



        $scope.getmovies = function () {
            return $scope.movies;
        }
        $scope.doSomething = function (typedthings) {
            $scope.spinner = true;
            $scope.newmovies = MovieRetriever.getmovies(typedthings);
            $scope.newmovies.then(function (data) {
                $scope.movies = data;
                $scope.spinner = false;
            });
        }

        $scope.gotohome = function () {
            $location.path('/')
        }
        $scope.getdocNumber = function () {
            return $scope.docnumber;
        }
        $scope.searchdoc1 = function (typedthings) {
            $scope.spinner = true;
            $scope.response = MovieRetriever.getdocNumber(typedthings);
            $scope.response.then(function (data) {
                $scope.docnumber = data;
                $scope.spinner = false;
            });
        }
        $scope.getPcnNumber = function () {
            return $scope.pcnnumber;
        }
        $scope.searchpcn = function (typedthings) {
            $scope.spinner = true;
            $scope.response = MovieRetriever.getPcnNumber(typedthings);
            $scope.response.then(function (data) {
                $scope.pcnnumber = data;
                $scope.spinner = false;

            });
        }
        $scope.getEtoNumber = function () {
            return $scope.etonumber;
        }

        $scope.searcheto = function (typedthings) {
            $scope.spinner = true;
            $scope.response = MovieRetriever.getEtoNumber(typedthings);
            $scope.response.then(function (data) {
                $scope.etonumber = data;
                $scope.spinner = false;
            });
        }
        $scope.getLedNumber = function () {
            return $scope.lednumber;
        }

        $scope.ledsearch = function (typedthings) {
            $scope.spinner = true;
            $scope.response = MovieRetriever.getLEDNumber(typedthings);
            $scope.response.then(function (data) {
                $scope.lednumber = data;
                $scope.spinner = false;
            });
        }
        $scope.searchshow = function () {

            $scope.form1 = true;
            $scope.list1 = false;

        }


        //$scope.searchshow = function (ev) {
        //    $mdDialog.show({
        //        controller: ['items', function (items) { this.items = items; }],
        //        controllerAs: 'ctrl',
        //        templateUrl: '../partformsearch.html',
        //        parent: angular.element(document.body),
        //        targetEvent: ev,
        //        locals: {
        //            items: $scope.items1
        //        },
        //        clickOutsideToClose: true,
        //        fullscreen: $scope.customFullscreen // Only for -xs, -sm breakpoints.
        //    })
        //  .then(function (answer) {
        //      $scope.status = 'You said the information was "' + answer + '".';
        //  }, function () {
        //      $scope.status = 'You cancelled the dialog.';
        //  });
        //}
        $scope.current = { value: 0, label: "All" };
        $scope.hide = function () {

            $mdDialog.hide();
        };


        $scope.cancel = function () {

            $mdDialog.cancel();
        };
        $scope.resetValue = function () {
            //$scope.current = undefined; 

            $scope.partStatus = { value: 0, label: "All" }
            $scope.PartType = { value: 0, label: "All" }
            if (angular.isDefined($scope.partNumber)) {
                $scope.partNumber = '';
            }
            if (angular.isDefined($scope.LegPartNumer)) {
                $scope.LegPartNumer = '';
            }
            if (angular.isDefined($scope.DocNumber)) {
                $scope.DocNumber = '';
            }
            if (angular.isDefined($scope.LegDocNumber)) {
                $scope.LegDocNumber = '';
            }
            if (angular.isDefined($scope.PartDescription)) {
                $scope.PartDescription = '';
            }
        };

        $scope.resetDocValue = function () {
            //$scope.current = undefined; 
            //debugger; 
            //alert("test") 
            if (angular.isDefined($scope.docStatus)) {
                $scope.docStatus = { value: 0, label: "All" };
            }

            if (angular.isDefined($scope.docType)) {
                $scope.docType = { value: 0, label: "All" };
            }

            if (angular.isDefined($scope.documentNumber)) {
                $scope.documentNumber = '';
            }

            if (angular.isDefined($scope.documentDescription)) {
                $scope.documentDescription = '';
            }

            if (angular.isDefined($scope.legacyPartNumber)) {
                $scope.legacyPartNumber = '';
            }

            if (angular.isDefined($scope.LegDocumentNumber)) {
                $scope.LegDocumentNumber = '';
            }


        };

        $scope.resetLEDValue = function () {
            //debugger;

            //LED search does not work correctly after using “Clear Button” issue fixed on 28-08-2018. 
            if (angular.isDefined($scope.liftPartType)) {
                $scope.liftPartType = 0;
            }

            if (angular.isDefined($scope.liftpartNumber)) {
                $scope.liftpartNumber = '';
            }
            if (angular.isDefined($scope.liftDocNumber)) {
                $scope.liftDocNumber = '';
            }
            if (angular.isDefined($scope.Compwhereused)) {
                $scope.Compwhereused = '';
            }
            if (angular.isDefined($scope.Productwhere)) {
                $scope.Productwhere = '';
            }
            if (angular.isDefined($scope.liftdesc)) {
                $scope.liftdesc = '';
            }

            if (angular.isDefined($scope.WLLValue)) {
                $scope.WLLValue = 0.0;
            }
            if (angular.isDefined($scope.tarevalue)) {
                $scope.tarevalue = 0.0;
            }

            if (angular.isDefined($scope.liftpartStatus)) {
                $scope.liftpartStatus = 0;
            }

            if (angular.isDefined($scope.hasCertification)) {
                $scope.hasCertification = '';
            }

            if (angular.isDefined($scope.hasInsDoc)) {
                $scope.hasInsDoc = '';
            }


            if (angular.isDefined($scope.tare)) {
                $scope.tare = null;
            }

            if (angular.isDefined($scope.wll)) {
                $scope.wll = null;
            }

            if (angular.isDefined($scope.SearchBy)) {
                $scope.SearchBy = 0;
            }


        };

        $scope.resetpcnValue = function () {
            //alert("Hey Lokesh");         
            if (angular.isDefined($scope.pcnNumber)) {
                $scope.pcnNumber = '';
            }
            if (angular.isDefined($scope.PcnDescription)) {
                $scope.PcnDescription = '';
            }
            if (angular.isDefined($scope.problemPart)) {
                $scope.problemPart = '';
            }
            if (angular.isDefined($scope.solutionPart)) {
                $scope.solutionPart = '';
            }
            if (angular.isDefined($scope.impectedPart)) {
                $scope.impectedPart = '';
            }
        };

        $scope.resetETOValue = function () {
            debugger;

            if (angular.isDefined($scope.etoNumber)) {
                delete $scope.etoNumber;
            }
            if (angular.isDefined($scope.gaGrowing)) {
                delete $scope.gaGrowing;
            }
            if (angular.isDefined($scope.projectName)) {
                delete $scope.projectName;
            }
            if (angular.isDefined($scope.orderNumber)) {
                delete $scope.orderNumber;
            }
            if (angular.isDefined($scope.customerName)) {
                delete $scope.customerName;
            }
            if (angular.isDefined($scope.document)) {
                delete $scope.document;
            }
            if (angular.isDefined($scope.orderParts)) {
                delete $scope.orderParts;
            }
            if (angular.isDefined($scope.reference)) {
                delete $scope.reference;
            }
        };



        $scope.logout = function () {
            localStorage.removeItem('username');
            $scope.isAuth = false;
            $http.get('home/Logout').then(function () {
                window.location.reload();
            });



        }
        $scope.gotoBottom = function () {
            // set the location.hash to the id of
            // the element you wish to scroll to.
            $("html,body").animate({ scrollTop: 400 }, "slow");
        };
        $scope.gotoTop = function () {

            $scope.itemlist = null;

            $('#scrollArea').animate({ scrollTop: 0 }, 100);
        };
        //$scope.items = [];
        $scope.customFullscreen = false;
        $scope.list = false;
        $scope.form = true;

        $scope.sort = function (keyname) {
            $scope.sortKey = keyname;   //set the sortKey to the param passed
            $scope.reverse = !$scope.reverse; //if true make it false and vice versa
        }
        
        $scope.forget = function (ev) {
            // Appending dialog to document.body to cover sidenav in docs app
            var confirm = $mdDialog.prompt()
                .title('Forgot Password')
                .placeholder('Enter your email')
                .targetEvent(ev)
                .required(true)
                .ok('Okay!')
                .cancel('Cancel');
            $mdDialog.show(confirm).then(function (result) {

                $http({
                    method: 'Get',
                    url: 'Home/ForgetPassword?email=' + result,
                    ContentType: 'json',
                })
                    .then(function (data, status, headers, config) {
                        console.log(data.data)
                        if (data.data == "1") {
                            $scope.message = "Your password hasbeen sent on your registerd email. Please check your mail";
                            $scope.color = "green"

                        } else if (data.data == "0") {
                            $scope.message = "Your email is invalid";
                            $scope.color = "red";
                        } else if (data.data == "2") {
                            $scope.color = "red";
                            $scope.message = "There is problem in sending email. server mail is not configured";
                        }
                    });

            }, function () {
                $scope.status = 'You didn\'t  your email';
            });
        };
        $scope.hasInsDoc = 0;
        $scope.hasCertification = 0;
        $scope.ViewDeatails = function (Id) {
            $http({
                method: 'Get',
                url: 'Home/GetPartdetail/' + Id,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    $scope.items1 = null;
                    $scope.items1 = data1.data;
                    console.log($scope.items1)
                })
        };

        $scope.ViewDeatails1 = function (Id, index) {
            $http({
                method: 'Get',
                url: 'Home/Getledsearchdetail/' + Id,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {

                    //$scope.items2 = data1.data;
                    $scope.leddatalist[index].leddetail = data1.data;
                    //console.log($scope.items2)
                    console.log(data1.data)
                })
        };
        $scope.getpcndetail = function (id, index) {
            debugger
            $http({
                method: 'Get',
                url: 'Home/Getpcndetail/' + id,
                ContentType: 'json',
            }).then(function (data, status, headers, config) {
                debugger
                $scope.pcdatalist[index].pcndetail = data.data;
                console.log(data.data)
            })
        }

        $scope.getledsearchdetail = function (id, index) {
            debugger
            alert("TEST");
            $http({
                method: 'Get',
                url: 'Home/Getledsearchdetail/' + id,
                ContentType: 'json',
            }).then(function (data, status, headers, config) {
                debugger

                //$scope.leddatalist[index].etodocdetail = data.data;
                $scope.leddatalist[index].leddetail = data.data;
                console.log(data.data)
            })
        }



        $scope.getetodetail = function (id, index) {
            $http({
                method: 'Get',
                url: 'Home/Getetodetail/' + id,
                ContentType: 'json',
            })
                .then(function (data, status, headers, config) {
                    debugger
                    $scope.etodatalist[index].etodetail = data.data;
                    //$scope.etodetail = data.data;
                    //console.log(data)
                })

        };
        $scope.getLEDstatus = function () {
            $http({
                method: 'Get',
                url: 'Home/GetLEDStatus',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.itemgetLEDStatuslist = data1.data;
                console.log(data1)
            })
        }
        $scope.getitemstatus = function () {
            $http({
                method: 'Get',
                url: 'Home/GetPartStatus',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.itemstatuslist = data1.data;

                // Below line added to fix JIRA issue APPS0002-164  
                $scope.partStatus = $scope.itemstatuslist[0];
                $scope.partStatus.value = $scope.itemstatuslist[0].oid;

                console.log(data1)
            })
        }
        $scope.getcontrol = function () {
            $http({
                method: 'Get',
                url: 'Home/GetControls',
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    $scope.controlilist = data1.data;
                    console.log(data1)
                })
        }
        $scope.getitemtype = function () {
            $http({
                method: 'Get',
                url: 'Home/GetPartType',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.itemtypelist = data1.data;
                console.log(data1)
            })
        }
        $scope.getLEDtype = function () {
            $http({
                method: 'Get',
                url: 'Home/GetLEDType',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.itemLEDlist = data1.data;
                console.log(data1)
            })
        }
        $scope.getdoctype = function () {
            $http({
                method: 'Get',
                url: 'Home/GetDocType',
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    $scope.itemDoclist = data1.data;
                    console.log(data1)
                })
        }
        $scope.getLEDtype = function () {
            $http({
                method: 'Get',
                url: 'Home/GetLEDType',
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    $scope.itemLEDlist = data1.data;
                    console.log(data1)
                })
        }
        $scope.getLEDStatus = function () {
            $http({
                method: 'Get',
                url: 'Home/GetLEDStatus',
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    $scope.itemgetLEDStatuslist = data1.data;
                    console.log(data1)
                })
        }


        $scope.sendtodoc1 = function (id) {
            var newpath = '/docsearch';
            var url = $location.$$absUrl.replace($location.$$path, newpath);
            var id1 = id.substring(0, id.indexOf('/'));
            //alert(id1);
            //cookiesave('id',id);
            var popup = window.open(url, 'sendtodoc');

            // check to see when opened page is ready
            var readyStateCheckInterval = setInterval(function () {
                if (popup.document.readyState === "complete") {
                    clearInterval(readyStateCheckInterval);
                    // function on App B
                    popup.functionToRunWhenReady(id1);
                }
            }, 10);
        };



        $scope.sendtodoc = function (id) {
            var newpath = '/docsearch';
            var url = $location.$$absUrl.replace($location.$$path, newpath);
            //cookiesave('id',id);
            var popup = window.open(url, 'sendtodoc');

            // check to see when opened page is ready
            var readyStateCheckInterval = setInterval(function () {
                if (popup.document.readyState === "complete") {
                    clearInterval(readyStateCheckInterval);
                    // function on App B
                    popup.functionToRunWhenReady(id);
                }
            }, 10);
        };


        $scope.sendtopart = function (id) {
            $scope.partNumber = id;
            localStorage.setItem('partnumber', id);
            $location.path('/partsearch');
            // setTimeout(function () {
            // $scope.Submitform();

            // }, 2000);
            $timeout(function () {

                angular.element(document.querySelector('.partbtn')).trigger('click');
                angular.element('.partbtn').triggerHandler('click');
            }, 1000);

        }


        $scope.list1 = false;
        $scope.list3 = false;
        $scope.list2 = false;
        $scope.list4 = false;
        $scope.list5 = false;


        $scope.Submitform = function () {
            var ss = localStorage.getItem('partnumber');
            if (ss)
                $scope.partNumber = ss;

            var data = {
                "Partnumber": $scope.partNumber,
                "LegPartNumer": $scope.LegPartNumer,
                "partStatus": $scope.partStatus,
                "DocNumber": $scope.DocNumber,
                "LegDocNumber": $scope.LegDocNumber,
                "PartType": $scope.PartType,
                "PartDescription": $scope.PartDescription,
            }

            if (!$scope.partStatus)
                $scope.partStatus = { value: 0 };

            if (!$scope.PartType)
                $scope.PartType = { value: 0 }

            $http({
                method: 'Get',
                url: 'Home/PartSearch?Partnumber=' + $scope.partNumber + "&LegPartNumer=" + $scope.LegPartNumer + "&partStatus=" + $scope.partStatus.value + "&DocNumber=" + $scope.DocNumber + "&LegDocNumber=" + $scope.LegDocNumber + "&PartType=" + $scope.PartType.value + "&PartDescription=" + $scope.PartDescription,
                ContentType: 'json',
                data: JSON.stringify(data),

            }).then(function (data1, status, headers, config) {

                $scope.list1 = true;
                $scope.list3 = false;
                $scope.list2 = false;
                $scope.list4 = false;
                $scope.list5 = false;
                if (data1.data != "1") {

                    localStorage.removeItem('partnumber')
                    $scope.itemlist = data1.data;


                    $scope.criteria = {
                        searchtext: '',

                        page: 1,
                        pagesize: 10,
                        sort: 'itemid',
                        desc: false
                    };
                    $scope.paging = {
                        total: 0,
                        totalpages: 0,
                        showing: 0,
                        pagearray: [],
                        pagingOptions: [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                    };

                    $scope.search = function () {
                        $scope.customers = ($filter('filter')(data1.data, { itemid: $scope.criteria.searchtext }));
                        console.log($scope.customers)
                        $scope.paging.total = $scope.customers.length;
                        var a = ($scope.criteria.page - 1) * $scope.criteria.pagesize;
                        var b = $scope.criteria.page * $scope.criteria.pagesize;

                        $scope.customers = $scope.customers.slice(a, b);

                        $scope.paging.showing = $scope.customers.length;
                        paging($scope.criteria.page, $scope.criteria.pagesize, $scope.paging.total);
                    }

                    function paging(current, pagesize, total) {
                        var totalpages = Math.ceil(total / pagesize);
                        $scope.paging.totalpages = totalpages;
                        // clear it before playing
                        $scope.paging.pagearray = [];
                        if (totalpages <= 1) return;


                        if (totalpages <= 5) {
                            for (var i = 1; i <= totalpages; i++)
                                $scope.paging.pagearray.push(i);
                        }

                        if (totalpages > 5) {
                            if (current <= 3) {
                                for (var i = 1; i <= 5; i++)
                                    $scope.paging.pagearray.push(i);

                                $scope.paging.pagearray.push('...');
                                $scope.paging.pagearray.push(totalpages);
                                $scope.paging.pagearray.push('Next');
                            }
                            else if (totalpages - current <= 3) {
                                $scope.paging.pagearray.push('Prev');
                                $scope.paging.pagearray.push(1);
                                $scope.paging.pagearray.push('..');
                                for (var i = totalpages - 4; i <= totalpages; i++)
                                    $scope.paging.pagearray.push(i);
                            }
                            else {
                                $scope.paging.pagearray.push('Prev');
                                $scope.paging.pagearray.push(1);
                                $scope.paging.pagearray.push('..');

                                for (var i = current - 2; i <= current + 2; i++)
                                    $scope.paging.pagearray.push(i);

                                $scope.paging.pagearray.push('...');
                                $scope.paging.pagearray.push(totalpages);
                                $scope.paging.pagearray.push('Next');
                            }
                        }
                    }

                    $scope.$watch('criteria', function (newValue, oldValue) {

                        if (!angular.equals(newValue, oldValue)) {
                            $scope.search();
                        }
                    }, true);

                    $scope.Prev = function () {
                        if ($scope.criteria.page >= 1)
                            $scope.criteria.page--;
                    }

                    $scope.Next = function () {
                        if ($scope.criteria.page < $scope.paging.totalpages)
                            $scope.criteria.page++;
                    }
                    $scope.gotoBottom();
                    $scope.search();

                } else
                    $scope.logout();
            })
        }


        /* replaced earlier function with this code on 24-Aug-2018 - JIRA APPS0002-169*/
        $scope.SearchLEDform = function () {

            var ss = localStorage.getItem('liftpartNumber');
            if (ss)
                $scope.liftpartNumber = ss;

            var data = {
                "liftpartNumber": $scope.liftpartNumber,
                "liftDocNumber": $scope.liftDocNumber,
                "liftPartType": $scope.liftPartType,
                "liftdesc": $scope.liftdesc,
                "Compwhereused": $scope.Compwhereused,
                "liftpartStatus": $scope.liftpartStatus,
                "Productwhere": $scope.Productwhere,
                "hasCertification": $scope.hasCertification,
                "hasInsDoc": $scope.hasInsDoc,
                "tare": $scope.tare,
                "tarevalue": $scope.tarevalue,
                "wll": $scope.wll,
                "WLLValue": $scope.WLLValue,
                "SearchBy": $scope.SearchBy
            }

            $http({
                method: 'Get',
                url: 'Home/LEDSearch?liftpartNumber=' + $scope.liftpartNumber + "&liftDocNumber=" + $scope.liftDocNumber + "&liftPartType=" + $scope.liftPartType + "&liftdesc=" + $scope.liftdesc + "&Compwhereused=" + $scope.Compwhereused + "&liftpartStatus=" + $scope.liftpartStatus + "&Productwhere=" + $scope.Productwhere + "&hasCertification=" + $scope.hasCertification + "&hasInsDoc=" + $scope.hasInsDoc + "&tare=" + $scope.tare + "&tarevalue=" + $scope.tarevalue + "&wll=" + $scope.wll + "&WLLValue=" + $scope.WLLValue + "&SearchBy=" + $scope.SearchBy,
                ContentType: 'json',
                data: JSON.stringify(data),

            }).then(function (data1, status, headers, config) {

                $scope.list1 = false;
                $scope.list3 = false;
                $scope.list2 = false;
                $scope.list4 = false;
                $scope.list5 = true;
                if (data1.data != "1") {

                    localStorage.removeItem('liftpartNumber')
                    $scope.ledlist = data1.data;


                    $scope.criteria = {
                        searchtext: '',

                        page: 1,
                        pagesize: 10,
                        sort: 'LEDItemID',
                        desc: false
                    };
                    $scope.paging = {
                        total: 0,
                        totalpages: 0,
                        showing: 0,
                        pagearray: [],
                        pagingOptions: [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                    };

                    $scope.search = function () {
                        var dadd = ($filter('unique')(data1.data, 'iid'));
                        $scope.leddatalist = ($filter('filter')(dadd, { LEDItemID: $scope.criteria.searchtext }));
                        //$scope.leddatalist = ($filter('filter')(data1.data, { LEDItemID: $scope.criteria.searchtext }));
                        console.log($scope.leddatalist)
                        $scope.paging.total = $scope.leddatalist.length;
                        var a = ($scope.criteria.page - 1) * $scope.criteria.pagesize;
                        var b = $scope.criteria.page * $scope.criteria.pagesize;

                        $scope.leddatalist = $scope.leddatalist.slice(a, b);

                        $scope.paging.showing = $scope.leddatalist.length;
                        paging($scope.criteria.page, $scope.criteria.pagesize, $scope.paging.total);
                    }

                    function paging(current, pagesize, total) {
                        var totalpages = Math.ceil(total / pagesize);
                        $scope.paging.totalpages = totalpages;
                        // clear it before playing
                        $scope.paging.pagearray = [];
                        if (totalpages <= 1) return;


                        if (totalpages <= 5) {
                            for (var i = 1; i <= totalpages; i++)
                                $scope.paging.pagearray.push(i);
                        }

                        if (totalpages > 5) {
                            if (current <= 3) {
                                for (var i = 1; i <= 5; i++)
                                    $scope.paging.pagearray.push(i);

                                $scope.paging.pagearray.push('...');
                                $scope.paging.pagearray.push(totalpages);
                                $scope.paging.pagearray.push('Next');
                            }
                            else if (totalpages - current <= 3) {
                                $scope.paging.pagearray.push('Prev');
                                $scope.paging.pagearray.push(1);
                                $scope.paging.pagearray.push('..');
                                for (var i = totalpages - 4; i <= totalpages; i++)
                                    $scope.paging.pagearray.push(i);
                            }
                            else {
                                $scope.paging.pagearray.push('Prev');
                                $scope.paging.pagearray.push(1);
                                $scope.paging.pagearray.push('..');

                                for (var i = current - 2; i <= current + 2; i++)
                                    $scope.paging.pagearray.push(i);

                                $scope.paging.pagearray.push('...');
                                $scope.paging.pagearray.push(totalpages);
                                $scope.paging.pagearray.push('Next');
                            }
                        }
                    }

                    $scope.$watch('criteria', function (newValue, oldValue) {

                        if (!angular.equals(newValue, oldValue)) {
                            $scope.search();
                        }
                    }, true);

                    $scope.Prev = function () {
                        if ($scope.criteria.page >= 1)
                            $scope.criteria.page--;
                    }

                    $scope.Next = function () {
                        if ($scope.criteria.page < $scope.paging.totalpages)
                            $scope.criteria.page++;
                    }
                    $scope.gotoBottom();
                    $scope.search();

                } else
                    $scope.logout();
            })
        }

        /* commented this code on 24-Aug-2018 - JIRA APPS0002-169
        $scope.SearchLEDform = function () {
            $http({
                method: 'Get',
                url: 'Home/LEDSearch?liftpartNumber=' + $scope.liftpartNumber + "&liftDocNumber=" + $scope.liftDocNumber + "&liftPartType=" + $scope.liftPartType + "&liftdesc=" + $scope.liftdesc + "&Compwhereused=" + $scope.Compwhereused + "&liftpartStatus=" + $scope.liftpartStatus + "&Productwhere=" + $scope.Productwhere + "&hasCertification=" + $scope.hasCertification + "&hasInsDoc=" + $scope.hasInsDoc + "&tare=" + $scope.tare + "&tarevalue=" + $scope.tarevalue + "&wll=" + $scope.wll + "&WLLValue=" + $scope.WLLValue + "&SearchBy=" + $scope.SearchBy,
                ContentType: 'json',

            }).then(function (data1, status, headers, config) {
                if (data1.data != "1") {
                    //debugger;
                    $scope.ledlist = data1.data;
                    $scope.list1 = false;
                    $scope.list3 = false;
                    $scope.list2 = false;
                    $scope.list4 = false;
                    $scope.list5 = true;
                    //$scope.liftpartNumber = null;
                    $scope.criteria = {
                        searchtext: '',
                        page: 1,
                        pagesize: 10,
                        sort: 'LEDItemID',
                        desc: false
                    };
                    $scope.paging = {
                        total: 0,
                        totalpages: 0,
                        showing: 0,
                        pagearray: [],
                        pagingOptions: [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                    };

                    $scope.search = function () {
                        var dadd = ($filter('unique')(data1.data, 'iid'));
						$scope.leddatalist = ($filter('filter')(dadd, { LEDItemID: $scope.criteria.searchtext }));
						//$scope.leddatalist = ($filter('filter')(data1.data, { LEDItemID: $scope.criteria.searchtext }));
                        $scope.paging.total = $scope.leddatalist.length;
                        var a = ($scope.criteria.page - 1) * $scope.criteria.pagesize;
                        var b = $scope.criteria.page * $scope.criteria.pagesize;

                        $scope.leddatalist = $scope.leddatalist.slice(a, b);
                        $scope.paging.showing = $scope.leddatalist.length;
                        paging($scope.criteria.page, $scope.criteria.pagesize,
                            $scope.paging.total);
                    }

                    function paging(current, pagesize, total) {
                        var totalpages = Math.ceil(total / pagesize);
                        $scope.paging.totalpages = totalpages;
                        // clear it before playing
                        $scope.paging.pagearray = [];
                        if (totalpages <= 1) return;


                        if (totalpages <= 5) {
                            for (var i = 1; i <= totalpages; i++)
                                $scope.paging.pagearray.push(i);
                        }

                        if (totalpages > 5) {
                            if (current <= 3) {
                                for (var i = 1; i <= 5; i++)
                                    $scope.paging.pagearray.push(i);

                                $scope.paging.pagearray.push('...');
                                $scope.paging.pagearray.push(totalpages);
                                $scope.paging.pagearray.push('Next');
                            }
                            else if (totalpages - current <= 3) {
                                $scope.paging.pagearray.push('Prev');
                                $scope.paging.pagearray.push(1);
                                $scope.paging.pagearray.push('..');
                                for (var i = totalpages - 4; i <= totalpages; i++)
                                    $scope.paging.pagearray.push(i);
                            }
                            else {
                                $scope.paging.pagearray.push('Prev');
                                $scope.paging.pagearray.push(1);
                                $scope.paging.pagearray.push('..');

                                for (var i = current - 2; i <= current + 2; i++)
                                    $scope.paging.pagearray.push(i);

                                $scope.paging.pagearray.push('...');
                                $scope.paging.pagearray.push(totalpages);
                                $scope.paging.pagearray.push('Next');
                            }
                        }
                    }

                    $scope.$watch('criteria', function (newValue, oldValue) {

                        if (!angular.equals(newValue, oldValue)) {
                            $scope.search();
                        }
                    }, true);

                    $scope.Prev = function () {
                        if ($scope.criteria.page >= 1)
                            $scope.criteria.page--;
                    }

                    $scope.Next = function () {
                        if ($scope.criteria.page < $scope.paging.totalpages)
                            $scope.criteria.page++;
                    }
                    $scope.isPaneShown = false;
                    $scope.gotoBottom();
                } else
                    $scope.logout();
            });
        }
        */

        $scope.hasCertification = "";
        $scope.hasInsDoc = "";
        $scope.clcik = function () {
            $scope.items1 = null;
            $scope.customers = null;
            $scope.documentlist = null;
            $scope.pcdatalist = null;
            $scope.etodatalist = null;
            $scope.itemlist = null;
            $scope.doclist = null;
            $scope.pcnlist = null;
            $scope.etolist = null;
            $scope.ledlist = null;
            $scope.leddatalist = null;
            $scope.etolist = null;
        }

        $scope.Docsearchform = function () {
            $scope.isPaneShown = true;

            var ss = localStorage.getItem('docnumber');
            if (ss)
                $scope.documentNumber = ss;
            if (!$scope.docStatus)
                $scope.docStatus = { value: 0 };
            if (!$scope.docType)
                $scope.docType = { value: 0 };
            $http({
                method: 'Get',
                url: 'Home/DocSearch?documentNumber=' + $scope.documentNumber + "&legacyPartNumber=" + $scope.legacyPartNumber + "&docStatus=" + $scope.docStatus.value + "&documentDescription=" + $scope.documentDescription + "&LegDocumentNumber=" + $scope.LegDocumentNumber + "&docType=" + $scope.docType.value,
                ContentType: 'json',

            })
                .then(function (data1, status, headers, config) {
                    //console.log(data1)

                    if (data1.data[0] != "1") {
                        $scope.doclist = data1.data;
                        $scope.list2 = true;
                        localStorage.removeItem('docnumber')
                        $scope.list1 = false;
                        $scope.list3 = false;
                        $scope.list4 = false;
                        $scope.list5 = false;
                        // $scope.documentNumber = null;
                        $scope.criteria = {
                            searchtext: '',
                            page: 1,
                            pagesize: 10,
                            sort: 'drowingid',
                            desc: false
                        };
                        $scope.paging = {
                            total: 0,
                            totalpages: 0,
                            showing: 0,
                            pagearray: [],
                            pagingOptions: [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                        };

                        $scope.search = function () {
                            $scope.documentlist = ($filter('filter')(data1.data[0], { itemid: $scope.criteria.searchtext }));
                            $scope.paging.total = $scope.documentlist.length;
                            var a = ($scope.criteria.page - 1) * $scope.criteria.pagesize;
                            var b = $scope.criteria.page * $scope.criteria.pagesize;

                            $scope.documentlist = $scope.documentlist.slice(a, b);
                            $scope.paging.showing = $scope.documentlist.length;
                            paging($scope.criteria.page, $scope.criteria.pagesize,
                                $scope.paging.total);
                        }

                        function paging(current, pagesize, total) {
                            var totalpages = Math.ceil(total / pagesize);
                            $scope.paging.totalpages = totalpages;
                            // clear it before playing
                            $scope.paging.pagearray = [];
                            if (totalpages <= 1) return;


                            if (totalpages <= 5) {
                                for (var i = 1; i <= totalpages; i++)
                                    $scope.paging.pagearray.push(i);
                            }

                            if (totalpages > 5) {
                                if (current <= 3) {
                                    for (var i = 1; i <= 5; i++)
                                        $scope.paging.pagearray.push(i);

                                    $scope.paging.pagearray.push('...');
                                    $scope.paging.pagearray.push(totalpages);
                                    $scope.paging.pagearray.push('Next');
                                }
                                else if (totalpages - current <= 3) {
                                    $scope.paging.pagearray.push('Prev');
                                    $scope.paging.pagearray.push(1);
                                    $scope.paging.pagearray.push('..');
                                    for (var i = totalpages - 4; i <= totalpages; i++)
                                        $scope.paging.pagearray.push(i);
                                }
                                else {
                                    $scope.paging.pagearray.push('Prev');
                                    $scope.paging.pagearray.push(1);
                                    $scope.paging.pagearray.push('..');

                                    for (var i = current - 2; i <= current + 2; i++)
                                        $scope.paging.pagearray.push(i);

                                    $scope.paging.pagearray.push('...');
                                    $scope.paging.pagearray.push(totalpages);
                                    $scope.paging.pagearray.push('Next');
                                }
                            }
                        }
                        $scope.$watch('criteria', function (newValue, oldValue) {

                            if (!angular.equals(newValue, oldValue)) {
                                $scope.search();
                            }
                        }, true);

                        $scope.Prev = function () {
                            if ($scope.criteria.page >= 1)
                                $scope.criteria.page--;
                        }

                        $scope.Next = function () {
                            if ($scope.criteria.page < $scope.paging.totalpages)
                                $scope.criteria.page++;
                        }
                        $scope.isPaneShown = false;
                        $scope.gotoBottom();
                        $scope.search(); // added this method call on 24-Aug-2018 - JIRA APPS0002-169
                    } else
                        $scope.logout();
                })
        }

        /* replaced earlier function with this code on 24-Aug-2018 - JIRA APPS0002-169
        $scope.PCNsearchform = function () {
            var data = {
                "Pcnnumber": $scope.pcnNumber,
                "PcnDescription": $scope.pcnDescription,
                "problem": $scope.problemPart,
                "solution": $scope.solutionPart,
                "impected": $scope.impectedPart
            }

            $http({
                method: 'Get',
                url: 'Home/PcnSearch?Pcnnumber=' + $scope.pcnNumber + "&PcnDescription=" + $scope.pcnDescription + "&problem=" + $scope.problemPart + "&solution=" + $scope.solutionPart + "&impected=" + $scope.impectedPart,
                ContentType: 'json',
                data: JSON.stringify(data),

            }).then(function (data1, status, headers, config) {

                $scope.list1 = false;
                $scope.list3 = true;
                $scope.list2 = false;
                $scope.list4 = false;
                $scope.list5 = false;
                if (data1.data != "1") {

                    //localStorage.removeItem('liftpartNumber')
                    $scope.pcnlist = data1.data;


                    $scope.criteria = {
                        searchtext: '',

                        page: 1,
                        pagesize: 10,
                        sort: 'drawingid',
                        desc: false
                    };
                    $scope.paging = {
                        total: 0,
                        totalpages: 0,
                        showing: 0,
                        pagearray: [],
                        pagingOptions: [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                    };

                    $scope.search = function () {
                        var dadd = ($filter('unique')(data1.data, 'pcnid'));
                        $scope.pcdatalist = ($filter('filter')(dadd, { pcnid: $scope.criteria.searchtext }));
                        //$scope.leddatalist = ($filter('filter')(data1.data, { LEDItemID: $scope.criteria.searchtext }));
                        console.log($scope.pcdatalist)
                        $scope.paging.total = $scope.pcdatalist.length;
                        var a = ($scope.criteria.page - 1) * $scope.criteria.pagesize;
                        var b = $scope.criteria.page * $scope.criteria.pagesize;

                        $scope.pcdatalist = $scope.pcdatalist.slice(a, b);

                        $scope.paging.showing = $scope.pcdatalist.length;
                        paging($scope.criteria.page, $scope.criteria.pagesize, $scope.paging.total);
                    }

                    function paging(current, pagesize, total) {
                        var totalpages = Math.ceil(total / pagesize);
                        $scope.paging.totalpages = totalpages;
                        // clear it before playing
                        $scope.paging.pagearray = [];
                        if (totalpages <= 1) return;


                        if (totalpages <= 5) {
                            for (var i = 1; i <= totalpages; i++)
                                $scope.paging.pagearray.push(i);
                        }

                        if (totalpages > 5) {
                            if (current <= 3) {
                                for (var i = 1; i <= 5; i++)
                                    $scope.paging.pagearray.push(i);

                                $scope.paging.pagearray.push('...');
                                $scope.paging.pagearray.push(totalpages);
                                $scope.paging.pagearray.push('Next');
                            }
                            else if (totalpages - current <= 3) {
                                $scope.paging.pagearray.push('Prev');
                                $scope.paging.pagearray.push(1);
                                $scope.paging.pagearray.push('..');
                                for (var i = totalpages - 4; i <= totalpages; i++)
                                    $scope.paging.pagearray.push(i);
                            }
                            else {
                                $scope.paging.pagearray.push('Prev');
                                $scope.paging.pagearray.push(1);
                                $scope.paging.pagearray.push('..');

                                for (var i = current - 2; i <= current + 2; i++)
                                    $scope.paging.pagearray.push(i);

                                $scope.paging.pagearray.push('...');
                                $scope.paging.pagearray.push(totalpages);
                                $scope.paging.pagearray.push('Next');
                            }
                        }
                    }

                    $scope.$watch('criteria', function (newValue, oldValue) {

                        if (!angular.equals(newValue, oldValue)) {
                            $scope.search();
                        }
                    }, true);

                    $scope.Prev = function () {
                        if ($scope.criteria.page >= 1)
                            $scope.criteria.page--;
                    }

                    $scope.Next = function () {
                        if ($scope.criteria.page < $scope.paging.totalpages)
                            $scope.criteria.page++;
                    }
                    $scope.isPaneShown = false;
                    $scope.gotoBottom();
                    $scope.search();

                } else
                    $scope.logout();
            })
        }
        */

        $scope.PCNsearchform = function () {
            $http({
                method: 'Get',
                url: 'Home/PcnSearch?Pcnnumber=' + $scope.pcnNumber + "&PcnDescription=" + $scope.pcnDescription + "&problem=" + $scope.problemPart + "&solution=" + $scope.solutionPart + "&impected=" + $scope.impectedPart,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    if (data1.data != "1") {
                        $scope.pcnlist = data1.data;
                        console.log($scope.pcnlist)
                        $scope.list2 = false;
                        $scope.list1 = false;
                        $scope.list4 = false;
                        $scope.list5 = false;
                        $scope.list3 = true;
                        // $scope.pcnNumber = null;
                        $scope.criteria = {
                            searchtext: '',
                            page: 1,
                            pagesize: 10,
                            sort: 'drawingid',
                            desc: false
                        };
                        $scope.paging = {
                            total: 0,
                            totalpages: 0,
                            showing: 0,
                            pagearray: [],
                            pagingOptions: [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                        };

                        var dadd = ($filter('unique')(data1.data, 'pcnid'));
                        debugger
                        $scope.search = function () {
                            $scope.pcdatalist = ($filter('filter')(dadd, { pcnid: $scope.criteria.searchtext }));
                            //$scope.pcdatalist = ($filter('filter')(data1.data, { pcnid: $scope.criteria.searchtext }));
                            $scope.paging.total = $scope.pcdatalist.length;
                            var a = ($scope.criteria.page - 1) * $scope.criteria.pagesize;
                            var b = $scope.criteria.page * $scope.criteria.pagesize;

                            $scope.pcdatalist = $scope.pcdatalist.slice(a, b);
                            $scope.paging.showing = $scope.pcdatalist.length;
                            paging($scope.criteria.page, $scope.criteria.pagesize,
                                $scope.paging.total);
                        }

                        function paging(current, pagesize, total) {
                            var totalpages = Math.ceil(total / pagesize);
                            $scope.paging.totalpages = totalpages;
                            // clear it before playing
                            $scope.paging.pagearray = [];
                            if (totalpages <= 1) return;


                            if (totalpages <= 5) {
                                for (var i = 1; i <= totalpages; i++)
                                    $scope.paging.pagearray.push(i);
                            }

                            if (totalpages > 5) {
                                if (current <= 3) {
                                    for (var i = 1; i <= 5; i++)
                                        $scope.paging.pagearray.push(i);

                                    $scope.paging.pagearray.push('...');
                                    $scope.paging.pagearray.push(totalpages);
                                    $scope.paging.pagearray.push('Next');
                                }
                                else if (totalpages - current <= 3) {
                                    $scope.paging.pagearray.push('Prev');
                                    $scope.paging.pagearray.push(1);
                                    $scope.paging.pagearray.push('..');
                                    for (var i = totalpages - 4; i <= totalpages; i++)
                                        $scope.paging.pagearray.push(i);
                                }
                                else {
                                    $scope.paging.pagearray.push('Prev');
                                    $scope.paging.pagearray.push(1);
                                    $scope.paging.pagearray.push('..');

                                    for (var i = current - 2; i <= current + 2; i++)
                                        $scope.paging.pagearray.push(i);

                                    $scope.paging.pagearray.push('...');
                                    $scope.paging.pagearray.push(totalpages);
                                    $scope.paging.pagearray.push('Next');
                                }
                            }
                        }
                        $scope.$watch('criteria', function (newValue, oldValue) {

                            if (!angular.equals(newValue, oldValue)) {
                                $scope.search();
                            }
                        }, true);

                        $scope.Prev = function () {
                            if ($scope.criteria.page >= 1)
                                $scope.criteria.page--;
                        }

                        $scope.Next = function () {
                            if ($scope.criteria.page < $scope.paging.totalpages)
                                $scope.criteria.page++;
                        }
                        $scope.isPaneShown = false;
                        $scope.gotoBottom();
                        $scope.search(); // added this method call on 24-Aug-2018 - JIRA APPS0002-169
                    } else
                        $scope.logout();
                })
        }


        $scope.LEDsearchform = function () {
            $scope.isPaneShown = true;
            $http({
                method: 'Get',
                url: 'Home/LEDSearch?liftpartNumber=' + $scope.liftpartNumber + "&liftDocNumber=" + $scope.liftDocNumber + "&liftPartType=" + $scope.liftPartType.value + "&liftdesc=" + $scope.liftdesc + "&impeCompwhereusedcted=" + $scope.Compwhereused + "&Productwhere=" + $scope.Productwhere + "&liftpartStatus=" + $scope.liftpartStatus.value + "&hasCertification=" + $scope.hasCertification.value + "&hasInsDoc=" + $scope.hasInsDoc.value + "&tarevalue=" + $scope.tarevalue + "&WLLValue=" + $scope.WLLValue + "&SearchBy=" + $scope.SearchBy,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    if (data1.data != "1") {
                        $scope.pcnlist = data1.data;
                        $scope.list2 = false;
                        $scope.list1 = false;
                        $scope.list4 = false;
                        $scope.list3 = true;
                        $scope.list5 = false;
                        //$scope.pcnNumber = null;
                        $scope.criteria = {
                            searchtext: '',
                            page: 1,
                            pagesize: 10,
                            sort: 'drowingid',
                            desc: false
                        };
                        $scope.paging = {
                            total: 0,
                            totalpages: 0,
                            showing: 0,
                            pagearray: [],
                            pagingOptions: [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                        };

                        $scope.search = function () {
                            $scope.pcdatalist = ($filter('filter')(data1.data, { pcnid: $scope.criteria.searchtext }));
                            $scope.paging.total = $scope.pcdatalist.length;
                            var a = ($scope.criteria.page - 1) * $scope.criteria.pagesize;
                            var b = $scope.criteria.page * $scope.criteria.pagesize;

                            $scope.pcdatalist = $scope.pcdatalist.slice(a, b);
                            $scope.paging.showing = $scope.pcdatalist.length;
                            paging($scope.criteria.page, $scope.criteria.pagesize,
                                $scope.paging.total);
                        }

                        function paging(current, pagesize, total) {
                            var totalpages = Math.ceil(total / pagesize);
                            $scope.paging.totalpages = totalpages;
                            // clear it before playing
                            $scope.paging.pagearray = [];
                            if (totalpages <= 1) return;


                            if (totalpages <= 5) {
                                for (var i = 1; i <= totalpages; i++)
                                    $scope.paging.pagearray.push(i);
                            }

                            if (totalpages > 5) {
                                if (current <= 3) {
                                    for (var i = 1; i <= 5; i++)
                                        $scope.paging.pagearray.push(i);

                                    $scope.paging.pagearray.push('...');
                                    $scope.paging.pagearray.push(totalpages);
                                    $scope.paging.pagearray.push('Next');
                                }
                                else if (totalpages - current <= 3) {
                                    $scope.paging.pagearray.push('Prev');
                                    $scope.paging.pagearray.push(1);
                                    $scope.paging.pagearray.push('..');
                                    for (var i = totalpages - 4; i <= totalpages; i++)
                                        $scope.paging.pagearray.push(i);
                                }
                                else {
                                    $scope.paging.pagearray.push('Prev');
                                    $scope.paging.pagearray.push(1);
                                    $scope.paging.pagearray.push('..');

                                    for (var i = current - 2; i <= current + 2; i++)
                                        $scope.paging.pagearray.push(i);

                                    $scope.paging.pagearray.push('...');
                                    $scope.paging.pagearray.push(totalpages);
                                    $scope.paging.pagearray.push('Next');
                                }
                            }
                        }
                        $scope.$watch('criteria', function (newValue, oldValue) {

                            if (!angular.equals(newValue, oldValue)) {
                                $scope.search();
                            }
                        }, true);

                        $scope.Prev = function () {
                            if ($scope.criteria.page >= 1)
                                $scope.criteria.page--;
                        }

                        $scope.Next = function () {
                            if ($scope.criteria.page < $scope.paging.totalpages)
                                $scope.criteria.page++;
                        }
                        $scope.isPaneShown = false;
                        $scope.gotoBottom();
                    } else
                        $scope.logout();
                })
        }

        $scope.Etosearchform = function () {
            $scope.isPaneShown = true;
            $http({
                method: 'Get',
                url: 'Home/EtoSearch?Etonumber=' + $scope.etoNumber + "&projectName=" + $scope.projectName + "&ordernumber="
                    + $scope.orderNumber + "&customername=" + $scope.customerName + "&gag=" + $scope.gaGrowing + "&doc=" + $scope.document
                    + "&routing=" + $scope.routing + "&orderpart=" + $scope.orderParts + "&reference=" + $scope.reference,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {

                    if (data1.data != "1") {
                        $scope.etolist = data1.data;
                        $scope.list2 = false;
                        $scope.list1 = false;
                        $scope.list4 = true;
                        $scope.list3 = false;
                        $scope.list5 = false;
                        // $scope.etoNumber = null;
                        $scope.criteria = {
                            searchtext: '',
                            page: 1,
                            pagesize: 10,
                            sort: 'drowingid',
                            desc: false
                        };
                        $scope.paging = {
                            total: 0,
                            totalpages: 0,
                            showing: 0,
                            pagearray: [],
                            pagingOptions: [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                        };
                        var dadd = ($filter('unique')(data1.data, 'eid'));
                        $scope.search = function () {
                            $scope.etodatalist = ($filter('filter')(dadd, { etoid: $scope.criteria.searchtext }));
                            $scope.paging.total = $scope.etodatalist.length;
                            var a = ($scope.criteria.page - 1) * $scope.criteria.pagesize;
                            var b = $scope.criteria.page * $scope.criteria.pagesize;

                            $scope.etodatalist = $scope.etodatalist.slice(a, b);
                            $scope.paging.showing = $scope.etodatalist.length;
                            paging($scope.criteria.page, $scope.criteria.pagesize,
                                $scope.paging.total);
                        }

                        function paging(current, pagesize, total) {
                            var totalpages = Math.ceil(total / pagesize);
                            $scope.paging.totalpages = totalpages;
                            // clear it before playing
                            $scope.paging.pagearray = [];
                            if (totalpages <= 1) return;


                            if (totalpages <= 5) {
                                for (var i = 1; i <= totalpages; i++)
                                    $scope.paging.pagearray.push(i);
                            }

                            if (totalpages > 5) {
                                if (current <= 3) {
                                    for (var i = 1; i <= 5; i++)
                                        $scope.paging.pagearray.push(i);

                                    $scope.paging.pagearray.push('...');
                                    $scope.paging.pagearray.push(totalpages);
                                    $scope.paging.pagearray.push('Next');
                                }
                                else if (totalpages - current <= 3) {
                                    $scope.paging.pagearray.push('Prev');
                                    $scope.paging.pagearray.push(1);
                                    $scope.paging.pagearray.push('..');
                                    for (var i = totalpages - 4; i <= totalpages; i++)
                                        $scope.paging.pagearray.push(i);
                                }
                                else {
                                    $scope.paging.pagearray.push('Prev');
                                    $scope.paging.pagearray.push(1);
                                    $scope.paging.pagearray.push('..');

                                    for (var i = current - 2; i <= current + 2; i++)
                                        $scope.paging.pagearray.push(i);

                                    $scope.paging.pagearray.push('...');
                                    $scope.paging.pagearray.push(totalpages);
                                    $scope.paging.pagearray.push('Next');
                                }
                            }
                        }
                        $scope.$watch('criteria', function (newValue, oldValue) {

                            if (!angular.equals(newValue, oldValue)) {
                                $scope.search();
                            }
                        }, true);

                        $scope.Prev = function () {
                            if ($scope.criteria.page >= 1)
                                $scope.criteria.page--;
                        }

                        $scope.Next = function () {
                            if ($scope.criteria.page < $scope.paging.totalpages)
                                $scope.criteria.page++;
                        }
                        $scope.isPaneShown = false;
                        $scope.gotoBottom();
                        $scope.search(); // added this method call on 24-Aug-2018 - JIRA APPS0002-169
                    } else
                        $scope.logout();
                })
        }

        $scope.SubmitformEnter = function ($event) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13) {
                $scope.Submitform();
            }

        };
        $scope.DocsearchformEnter = function ($event) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13) {
                $scope.Docsearchform();
            }

        };
        $scope.loginter = function ($event) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13) {
                $scope.login();
            }

        };
        $scope.PCNsearchformEnter = function ($event) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13) {
                $scope.PCNsearchform();
            }

        };
        $scope.SearchLEDformEnter = function ($event) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13) {
                $scope.SearchLEDform();
            }

        };
        $scope.EtosearchformEnter = function ($event) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13) {
                $scope.Etosearchform();
            }
        };
        
    });
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
})();

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