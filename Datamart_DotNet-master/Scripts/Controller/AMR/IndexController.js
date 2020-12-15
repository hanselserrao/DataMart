(function () {
    app.controller('AMRIndexCtrl', function ($scope, $http, $filter, $anchorScroll, $location, $compile, $mdDialog, $timeout, $q, appService, MovieRetriever, $window, cfpLoadingBar, $route, $templateCache) {

        $scope.start = function () {
            cfpLoadingBar.start();
        };
        $scope.amrData = "";
        $scope.color = "red";
        $scope.errordiv = false;
        $scope.UserList = false;
        $scope.amrDueDate = new Date();
        $scope.getMinDate = function () {
            return new Date(
                $scope.amrDueDate.getFullYear(),
                $scope.amrDueDate.getMonth(),
                $scope.amrDueDate.getDate());
        }
        $scope.minDate = $scope.getMinDate();

        $scope.complete = function () {
            cfpLoadingBar.complete();
        }

        $scope.isexpanded = false;
        $scope.expandCollapseAll = function (isexpanded, typelist) {
            typelist.forEach(function (val) {
                val.expanded = isexpanded;
            })
        }

        $scope.uploadFile = function () {
            var file = $scope.myFile;

            console.log('file is ');
            console.dir(file);

            var uploadUrl = "AMR/Upload";
            appService.uploadFileToUrl(file, uploadUrl);
        };

        $scope.AMRsearchformEnter = function ($event) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13) {
                $scope.AMRSearchForm();
            }
        };

        $scope.SubmitAMRFormEnter = function ($event, invalidform) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13 && !invalidform) {
                $scope.SubmitAMRRequestForm();
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


        $scope.resetAMRSearch = function () {
            //$scope.partStatus = { value: 0, label: "All" }
            if (angular.isDefined($scope.amrType)) {
                $scope.amrType = { value: 0, label: "All" };
            }
            if (angular.isDefined($scope.amrEmail)) {
                $scope.amrEmail = '';
            }
            if (angular.isDefined($scope.amrStatus)) {
                $scope.amrStatus = { value: 0, label: "All" };
            }
            if (angular.isDefined($scope.amrItemNo)) {
                $scope.amrItemNo = '';
            }
            if (angular.isDefined($scope.amrRequestNo)) {
                $scope.amrRequestNo = '';
            }
            if (angular.isDefined($scope.amrNewMaterialCode)) {
                $scope.amrNewMaterialCode = '';
            }
            if (angular.isDefined($scope.amrPartDescription)) {
                $scope.amrPartDescription = '';
            }
        };


        $scope.resetAMRRequestForm = function () {
            if (appService.getAuth().username == "Anonymous")
            {
                $scope.userEmail = "";
            }
            else
            {
                $scope.userEmail = appService.getAuth().username;
            }
            if (angular.isDefined($scope.amrPartStatus)) {
                $scope.amrPartStatus = { value: 0, label: "--Select--" };
            }
            if (angular.isDefined($scope.amrPartNo)) {
                $scope.amrPartNo = '';
            }
            if (angular.isDefined($scope.amrNewMaterialCode)) {
                $scope.amrNewMaterialCode = '';
            }
            if (angular.isDefined($scope.amrExistingMaterial)) {
                $scope.amrExistingMaterial = '';
            }
            if (angular.isDefined($scope.amrRequestNumber)) {
                $scope.amrRequestNumber = '';
            }
            if (angular.isDefined($scope.amrDrawingNumber)) {
                $scope.amrDrawingNumber = '';
            }
            if (angular.isDefined($scope.amrPartDescription)) {
                $scope.amrPartDescription = '';
            }
            if (angular.isDefined($scope.amrSite)) {
                $scope.amrSite = { value: 0, label: "--Select--" };
            }
            if (angular.isDefined($scope.amrPriority)) {
                $scope.amrPriority = { value: 0, label: "--Select--" };
            }
            if (angular.isDefined($scope.DCO)) {
                $scope.DCO = { value: 0, label: "--Select--" };
            }
            if (angular.isDefined($scope.amrDueDate)) {
                $scope.amrDueDate = '';
            }
            if (angular.isDefined($scope.amrDrawingRevNo)) {
                $scope.amrDrawingRevNo = '';
            }
            if (angular.isDefined($scope.amrCastingRequest)) {
                $scope.amrCastingRequest = 0;
            }
        };


        $scope.resetAMRBasicDataForm = function () {
            if (appService.getAuth().username == "Anonymous") {
                $scope.userEmail = "";
            }
            else {
                $scope.userEmail = appService.getAuth().username;
            }
            if (angular.isDefined($scope.amrProduct)) {
                $scope.amrProduct = { value: 0, label: "--Select--" };
            }
            if (angular.isDefined($scope.amrPartNo)) {
                $scope.amrPartNo = '';
            }
            if (angular.isDefined($scope.amrPartDescription)) {
                $scope.amrPartDescription = '';
            }
            if (angular.isDefined($scope.myFileField)) {
                $scope.myFileField = '';
            }
            if (angular.isDefined($scope.remarks)) {
                $scope.remarks = '';
            }
        };
        
        $scope.resetAMRDataIssueForm = function () {
            if (appService.getAuth().username == "Anonymous") {
                $scope.userEmail = "";
            }
            else {
                $scope.userEmail = appService.getAuth().username;
            }
            if (angular.isDefined($scope.amrProduct)) {
                $scope.amrProduct = { value: 0, label: "--Select--" };
            }
            if (angular.isDefined($scope.amrPartNo)) {
                $scope.amrPartNo = '';
            }
            if (angular.isDefined($scope.amrPartDescription)) {
                $scope.amrPartDescription = '';
            }
            if (angular.isDefined($scope.myFileForDataIssue)) {
                $scope.myFileForDataIssue = '';
            }
            if (angular.isDefined($scope.issuedescription)) {
                $scope.issuedescription = '';
            }
        };


        $scope.AMRSearchForm = function () {
            
            appService.loadAuth();
            if (!$scope.amrType)
                $scope.amrType = { value: 0 };

            if (!$scope.amrStatus)
                $scope.amrStatus = { value: 0 };

            $http({
                method: 'Get',
                url: 'AMR/AMRSearch?amrType=' + $scope.amrType.value + "&amrEmail=" + $scope.amrEmail + "&amrStatus=" + $scope.amrStatus.value + "&amrItemNo=" + $scope.amrItemNo + "&amrRequestNo=" + $scope.amrRequestNo + "&amrNewMaterialCode=" + $scope.amrNewMaterialCode + "&amrPartDescription=" + $scope.amrPartDescription,
                ContentType: 'json',
            })
                .then(function (data1, status, headers, config) {
                    //console.log(data1)
                    
                    if (data1.data != "1") {
                        $scope.amrlist = data1.data;
                        $scope.UserList = true;

                        // $scope.documentNumber = null;
                        $scope.criteria = {
                            searchtext: '',
                            page: 1,
                            pagesize: 10,
                            sort: 'amr_id',
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
                            $scope.amrlist = ($filter('filter')(data1.data, { amr_id: $scope.criteria.searchtext }));
                            $scope.paging.total = $scope.amrlist.length;
                            var a = ($scope.criteria.page - 1) * $scope.criteria.pagesize;
                            var b = $scope.criteria.page * $scope.criteria.pagesize;
                            $scope.amrlist = $scope.amrlist.slice(a, b);
                            $scope.paging.showing = $scope.amrlist.length;
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

        $scope.current = { value: 0, label: "All" };
        $scope.select = { value: 0, label: "--Select--" };

        $scope.getamrtype = function (PageType) {
            $http({
                method: 'Get',
                url: 'AMR/GetAMRType',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.amrtypelist = data1.data;
            })
        }

        $scope.getProduct = function (PageType) {
            $http({
                method: 'Get',
                url: 'AMR/GetProduct',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.amrProductList = data1.data;
            })
        }


        $scope.getamrstatus = function (PageType) {
            $http({
                method: 'Get',
                url: 'AMR/GetAMRStatus',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.amrstatuslist = data1.data;
            })
        }

        $scope.getpartstatus = function (PageType) {
            $http({
                method: 'Get',
                url: 'AMR/GetPartStatus',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.partstatuslist = data1.data;
            })
        }

        $scope.getsite = function (PageType) {
            $http({
                method: 'Get',
                url: 'AMR/GetSite',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.sitelist = data1.data;
            })
        }

        $scope.getpriority = function (PageType) {
            $http({
                method: 'Get',
                url: 'AMR/GetPriority',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.prioritylist = data1.data;
            })
        }

        $scope.getdco = function (PageType) {
            $http({
                method: 'Get',
                url: 'AMR/GetDCO',
                ContentType: 'json',
            }).then(function (data1, status, headers, config) {
                $scope.dcolist = data1.data;
            })
        }

        $scope.DisplayProblemReport = function () {
            $location.path('/AMR/CreateProblemReport');
            //appService.loadAuth();
            //if  (appService.getAuth().role.indexOf('AMRUser') != -1) 
            //    $location.path('/AMR/CreateProblemReport');
            //else
            //    $location.path('/admin');
        };

        $scope.SetAMRType = function (amrType) {
            $scope.amrData = amrType.name;
        };

        function convert(str) {
            var date = new Date(str),
                mnth = ("0" + (date.getMonth() + 1)).slice(-2),
                day = ("0" + date.getDate()).slice(-2);
            return [date.getFullYear(), mnth, day].join("-");
        }
        $scope.SubmitAMRRequestForm = function () {
            appService.loadAuth();
            var tempdate = '';
            /*if (appService.getAuth().role.indexOf('AMRUser') == -1) {
                $location.path('/login');
                return;
            }*/
            if (angular.isDefined($scope.amrDueDate) && $scope.amrDueDate !='') {
                tempdate = $scope.amrDueDate.toISOString().substr(0, 10);
                tempdate = convert($scope.amrDueDate);
            }
            //$scope.uploadFile();


            var file = $scope.myFile;
            var fd;
            //if (file) {
            //    fd = new FormData();
            //    fd.append('file', file);
            //}
            if ($scope.amrType.name == 'Request For Basic Data') {

                file = $scope.myFile;
                fd;
                if (file) {
                    fd = new FormData();
                    fd.append('file', file);
                }

                var url = 'AMR/CreateAMRRequest?amrType=' + $scope.amrType.oid + '&amrTypeName=' + $scope.amrType.name + '&userEmail=' + $scope.userEmail + '&amrPartStatus=' + $scope.amrPartStatus.value + "&amrPartNo=" + $scope.amrPartNo + "&amrPartDescription=" + $scope.amrPartDescription + "&amrNewMaterialCode=" + $scope.amrNewMaterialCode + "&amrExistingMaterial=" + $scope.amrExistingMaterial + "&amrRequestNumber=" + $scope.amrRequestNumber + "&amrDrawingNumber=" + $scope.amrDrawingNumber + "&amrDrawingRevNo=" + $scope.amrDrawingRevNo + "&amrSite=" + $scope.amrSite.value + "&amrPriority=" + $scope.amrPriority.value + "&amrDCO=" + $scope.amrDCO.value + "&amrDueDate=" + tempdate + "&amrCastingRequest=" + $scope.amrCastingRequest + "&productId=" + $scope.amrProduct.oid + "&remarks=" + encodeURIComponent($scope.remarks) + "&productName=" + $scope.amrProduct.name;
            }

            else if ($scope.amrType.name == 'Data Issue') {

                file = $scope.myFileForDataIssue;
                fd;
                if (file) {
                    fd = new FormData();
                    fd.append('file', file);
                }

                var url = 'AMR/CreateAMRRequest?amrType=' + $scope.amrType.oid + '&amrTypeName=' + $scope.amrType.name + '&userEmail=' + $scope.userEmail + '&amrPartStatus=' + $scope.amrPartStatus.value + "&amrPartNo=" + $scope.amrPartNo + "&amrPartDescription=" + $scope.amrPartDescription + "&amrNewMaterialCode=" + $scope.amrNewMaterialCode + "&amrExistingMaterial=" + $scope.amrExistingMaterial + "&amrRequestNumber=" + $scope.amrRequestNumber + "&amrDrawingNumber=" + $scope.amrDrawingNumber + "&amrDrawingRevNo=" + $scope.amrDrawingRevNo + "&amrSite=" + $scope.amrSite.value + "&amrPriority=" + $scope.amrPriority.value + "&amrDCO=" + $scope.amrDCO.value + "&amrDueDate=" + tempdate + "&amrCastingRequest=" + $scope.amrCastingRequest + "&productId=" + $scope.amrProduct.oid + "&remarks=" + encodeURIComponent($scope.issuedescription) + "&productName=" + $scope.amrProduct.name;
            }
            else {
                var url = 'AMR/CreateAMRRequest?amrType=' + $scope.amrType.oid + '&amrTypeName=' + $scope.amrType.name + '&userEmail=' + $scope.userEmail + '&amrPartStatus=' + $scope.amrPartStatus.value + "&amrPartNo=" + $scope.amrPartNo + "&amrPartDescription=" + $scope.amrPartDescription + "&amrNewMaterialCode=" + $scope.amrNewMaterialCode + "&amrExistingMaterial=" + $scope.amrExistingMaterial + "&amrRequestNumber=" + $scope.amrRequestNumber + "&amrDrawingNumber=" + $scope.amrDrawingNumber + "&amrDrawingRevNo=" + $scope.amrDrawingRevNo + "&amrSite=" + $scope.amrSite.value + "&amrPriority=" + $scope.amrPriority.value + "&amrDCO=" + $scope.amrDCO.value + "&amrDueDate=" + tempdate + "&amrCastingRequest=" + $scope.amrCastingRequest + "&productId=" + $scope.amrProduct.oid + "&remarks=" + encodeURIComponent($scope.remarks) + "&productName=" + $scope.amrProduct.name;
            }


            $http.post(url, fd, {
            transformRequest: angular.identity,
            headers: { 'Content-Type': undefined }
            })
                .then(function (data, status, headers, config) {
                    if (data.data != "1") {
                        if (data.data.ErrorNumber == 0) {
                            $scope.errormsg = data.data.ErrorMessage
                            $scope.color = "green"
                            $scope.errordiv = true;
                        }
                        else {
                            $scope.errormsg = data.data.ErrorMessage
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

    app.filter('nl2p', function () {
        return function (text) {
            text = String(text).trim();
            var kam = (text.length > 0 ? text.replace(/\\n/g, '<br>')  : null);
            return kam;
        }
    });


})();
