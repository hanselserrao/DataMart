(function () {
    'use strict';

    app.controller('adminIndexCtrl', function ($scope, $http, $filter, $anchorScroll, $location, $compile, $mdDialog, $timeout, $q, appService, MovieRetriever, $window, cfpLoadingBar, $route, $templateCache) {
        $scope.start = function () {
            cfpLoadingBar.start();
        };
        $scope.color = "red";
        $scope.errordiv = false;
        $scope.UserList = false;

        $scope.current = { value: 0, label: "All" };
        $scope.select = { value: 0, label: "--Select--" };

        $scope.complete = function () {
            cfpLoadingBar.complete();
        }

        $scope.AdminsearchformEnter = function ($event) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13) {
                $scope.AdminSearchForm();
            }
        };

        $scope.AddUserFormEnter = function ($event, invalidform) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13 && !invalidform) {
                $scope.AddUserSubmitForm();
            }
        };


        $scope.gotoBottom = function () {
            // set the location.hash to the id of
            // the element you wish to scroll to.
            $("html,body").animate({ scrollTop: 400 }, "slow");
        };
        $scope.gotoTop = function () {

            $scope.itemlist = null;

            $('#scrollArea').animate({ scrollTop: 0 }, 100);
        };


        $scope.resetAdminSearch = function () {
            //$scope.partStatus = { value: 0, label: "All" }
            if (angular.isDefined($scope.usrId)) {
                $scope.usrId = '';
            }
            if (angular.isDefined($scope.usrEmail)) {
                $scope.usrEmail = '';
            }
            if (angular.isDefined($scope.usrName)) {
                $scope.usrName = '';
            }
            if (angular.isDefined($scope.usrRole)) {
                $scope.usrRole = {value: 0, label: "All" };
            }
        };


        $scope.resetAddUserForm = function () {
            //$scope.partStatus = { value: 0, label: "All" }
            if (angular.isDefined($scope.userEmail)) {
                $scope.userEmail = '';
            }
            if (angular.isDefined($scope.usrRole)) {
                $scope.usrRole = { value: 1, label: "All" };
            }
            if (angular.isDefined($scope.firstName)) {
                $scope.firstName = '';
            }
            if (angular.isDefined($scope.lastName)) {
                $scope.lastName = '';
            }
            if (angular.isDefined($scope.userId)) {
                $scope.userId = '';
            }
            if (angular.isDefined($scope.appPwd)) {
                $scope.appPwd = '';
            }
            if (angular.isDefined($scope.userTitle)) {
                $scope.userTitle = '';
            }
            if (angular.isDefined($scope.companyName)) {
                $scope.companyName = '';
            }
            if (angular.isDefined($scope.userPhone)) {
                $scope.userPhone = '';
            }
            if (angular.isDefined($scope.userFax)) {
                $scope.userFax = '';
            }
        };

        $scope.getusertype = function (PageType) {
            $http({
                method: 'Get',
                url: 'Admin/GetUserType',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.userlist = data1.data;
            })
        }


        $scope.AdminSearchForm = function () {
            appService.loadAuth();
            if (appService.getAuth().role != "Admin") {
                $location.path('/admin');
                return;
            }
            if (!$scope.usrRole)
                $scope.usrRole = { value: 0 };

            $http({
                method: 'Get',
                url: 'Admin/UserSearch?userID=' + $scope.usrId + "&email=" + $scope.usrEmail + "&userName=" + $scope.usrName + "&userRole=" + $scope.usrRole.value,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    //console.log(data1)

                    if (data1.data != "1") {
                        $scope.userslist = data1.data;
                        $scope.UserList = true;

                        // $scope.documentNumber = null;
                        $scope.criteria = {
                            searchtext: '',
                            page: 1,
                            pagesize: 10,
                            sort: 'username',
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
                            $scope.userslist = ($filter('filter')(data1.data, { username: $scope.criteria.searchtext }));
                            $scope.paging.total = $scope.userslist.length;
                            var a = ($scope.criteria.page - 1) * $scope.criteria.pagesize;
                            var b = $scope.criteria.page * $scope.criteria.pagesize;
                            $scope.userslist = $scope.userslist.slice(a, b);
                            $scope.paging.showing = $scope.userslist.length;
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
                        //$scope.gotoBottom();
                        $scope.search(); // added this method call on 24-Aug-2018 - JIRA APPS0002-169
                    } else
                        $scope.logout();
                })
        }

        $scope.OpenAddUserForm = function () {
            appService.loadAuth();
            if (appService.getAuth().role == "Admin")
                $location.path('/admin/adduser');
            else
                $location.path('/admin');
        };

        $scope.AddUserSubmitForm = function () {
            appService.loadAuth();
            if (appService.getAuth().role != "Admin") {
                $location.path('/admin');
                return;
            }
            if (!$scope.usrRole)
                $scope.usrRole = { value: 0 };
            $http({
                method: 'get',
                url: 'Admin/AddUser?userEmail=' + $scope.userEmail + '&usrRole=' + $scope.usrRole.value + '&firstName=' + $scope.firstName + "&lastName=" + $scope.lastName + "&userId=" + $scope.userId + "&appPwd=" + $scope.appPwd + "&userTitle=" + $scope.userTitle + "&companyName=" + $scope.companyName + "&userPhone=" + $scope.userPhone + "&userFax=" + $scope.userFax,
                ContentType: 'json',
            })
                .then(function (data, status, headers, config) {
                    if (data.data != "1") {
                        if (data.data[0].ErrorNumber == 0) {
                            $scope.errormsg = data.data[0].ErrorMessage
                            $scope.color = "green"
                            $scope.errordiv = true;
                        }
                        else {
                            $scope.errormsg = data.data[0].ErrorMessage
                            $scope.color = "red"
                            $scope.errordiv = true;
                        }
                    }
                },
                    function (error) {
                        //appService.setAuth(false);
                        console.log(error)
                    }
                )
        };



        $scope.AdminOption = function () {
            $http.get('Admin/Index').then(function () {
                window.location.reload();
            });
        }
    });
})();
