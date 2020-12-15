(function () {
    'use strict';

    app.controller('loginCtrl', function ($scope, $http, $filter, $anchorScroll, $location, $compile, $mdDialog, $timeout, $q, appService, $window, cfpLoadingBar, $route, $templateCache) {
        $scope.email = '';
        $scope.defaultemail = '';
        $scope.password = '';
        $scope.paramContext = '';
        $scope.color = "red";
        $scope.errordiv = false;
        $scope.myPwdInvalid = false;

        $scope.login = function () {

            if ($route.current) {
                $scope.paramContext = $route.current.$$route.paramContext;
            }
            if ($scope.paramContext && $scope.paramContext!='') {}else{
                $scope.paramContext = appService.getRouteModel().paramContext;
            }

            $http({
                method: 'get',
                url: 'Home/Login1?email=' + $scope.email + '&password=' + $scope.password + "&context=" + $scope.paramContext,
                ContentType: 'json',
            })
                .then(function (data, status, headers, config) {
                    if (data.data.mode == 1) {
                        appService.setAuth({ username: data.data.username, role: data.data.role, isAuth: true });
                        
                        if (appService.getRouteModel().loginType == 'model') {
                            document.getElementById('close-modal').click();
                        }else{
                            if (($scope.paramContext) == "ADM")
                                $location.url('/admin/index');
                            else {
                                window.location.href = '/#/search';
                                
                            }
                        }
                        $scope.email = '';
                        $scope.password = '';
                        //window.location.reload();
                        $scope.errordiv = false;
                    }
                    else if (data.data.mode == 2) {
                        //appService.setAuth(false);
                        $scope.errordiv = true;
                        $scope.errormsg = "User not found. Please try again with correct email"
                    }
                    else if (data.data.mode == 3) {
                        //appService.setAuth(false);
                        $scope.errordiv = true;
                        $scope.errormsg = "Password not matched. Please try again"
                    }
                    else if (data.data.mode == 4) {
                        //appService.setAuth(false);
                        $scope.errordiv = true;
                        $scope.errormsg = "User is not active. Please contact Administrator"
                    } else if (data.data.mode == 5) {
                        $scope.message = "Please change password on first login";
                        $scope.color = "green";
                        $scope.defaultemail = data.data.username;
                        $scope.changepassword(this);
                    }
                    else {
                        //appService.setAuth(false);
                        $scope.errordiv = true;
                        $scope.errormsg = "Invalid login attempt"
                    }
                },
                    function (error) {
                        //appService.setAuth(false);
                        console.log(error)
                    }
                )
        };

        $scope.loginter = function ($event) {
            var keyCode = $event.which || $event.keyCode;
            if (keyCode === 13) {
                $scope.login();
            }
        }

        // for forget password
        function DialogController($scope, $mdDialog, items) {
            $scope.email = "";
            $scope.message = "";
            $scope.color = ""
            $scope.closeDialog = function () {
                console.log($scope.email);
                $mdDialog.hide();
            }

            $scope.submitDialog = function () {
                $http({
                    method: 'Get',
                    url: 'Home/ForgetPassword?email=' + $scope.email,
                    ContentType: 'json',
                })
                    .then(function (data, status, headers, config) {
                        console.log(data.data)
                        if (data.data == "1") {
                            $scope.message = "Your password sent on your registerd email. Please check your mail";
                            $scope.color = "green"
                        } else if (data.data == "0") {
                            $scope.message = "Your email is invalid";
                            $scope.color = "red";
                        } else if (data.data == "2") {
                            $scope.color = "red";
                            $scope.message = "There is problem in sending email. server mail is not configured";
                        }

                    });
            }
        }

        $scope.forget = function ($event) {
            var parentEl = angular.element(document.body);
            $mdDialog.show({
                parent: parentEl,
                title: 'Forgot Password',
                placeholder:'Enter your email',
                targetEvent: $event,
                template:
                    '<md-dialog aria-label="confirm-dialog">' +
                    '<div class="dialogHeading">' +
                        'Forgot Password' +
                    '</div>' +
                    '<center>' +
                    '<p>&nbsp;</p>' +
                    //'<form>' +
                        '<md-dialog-content>' +
                              '<label><h4>Enter Email : </h4></label>' +
                              ' <md-input-container style="width: 40%;"><input type="Email" name="email" placeholder="Enter your email" ng-model="email" minlength="8" required="" /> </md-input-container>' +
                        '</md-dialog-content>' +
                  '  <md-dialog-actions>' +
                  '     <div style="color:{{color}}">{{message}}</div> ' +
                  '    <md-button ng-click="submitDialog()" class="md-primary">' +
                  '      Submit' +
                  '    </md-button>' +
                  '    <md-button ng-click="closeDialog()" class="md-primary">' +
                  '      Close' +
                  '    </md-button>' +
                  '  </md-dialog-actions>' +
                    //'</form>' +
                    '</center>' +
                    '</md-dialog>' ,
                locals: {
                    items: $scope.items
                },
                controller: DialogController
            });
        }



        function DialogCntrChangePwd($scope, $mdDialog, items) {
            $scope.email = "";
            $scope.message = "";
            $scope.color = ""
            $scope.closeDialog = function () {
                $scope.defaultemail = "";
                $mdDialog.hide();
            }

            $scope.submitDialog = function () {
                $http({
                    method: 'Get',
                    url: 'Home/ChangePassword?email=' + $scope.email + "&password=" + $scope.password + "&newpassword=" + $scope.newpassword,
                    ContentType: 'json',
                })
                    .then(function (data, status, headers, config) {
                        console.log(data.data)
                        if (data.data.mode == 1) {
                            $scope.message = "Your password changed successfully.";
                            $scope.color = "green"

                        } else if (data.data.mode == 2) {
                            $scope.message = data.data.errormessage;
                            $scope.color = "red";
                        } else if (data.data.mode == 3) {
                            $scope.color = "red";
                            $scope.message = "Old Password not matched. Please try again";
                        } else if (data.data.mode == 4) {
                            $scope.color = "red";
                            $scope.message = "User is not active. Please contact Administrator";
                        } else if (data.data.mode == 5) {
                            $scope.color = "red";
                            $scope.message = "User not found. Please try again with correct email";
                        } else {
                            $scope.color = "red";
                            $scope.message = "Unexpected Error. Please contact Administrator";
                        }
                    });
            }
        }



        $scope.changepassword = function ($event) {
            var parentEl = angular.element(document.body);
            var templatehtml = '<md-dialog aria-label="confirm-dialog">' +
                    '<div class="dialogHeading">' +
                        'Change Password' + 
                    '</div>' +
                    '<center>' +
                    '<p>&nbsp;</p>' +
                   '<form name="myForm" novalidate>' +
                        '<md-dialog-content>' +
                              '<label style="width:200px"><h4 style="width:200px">Enter Email&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </h4></label>' 
                            if ($scope.defaultemail == '') {
                            templatehtml = templatehtml + ' <md-input-container style="width: 40%;"><input type="email" name="email" placeholder="Enter your email" ng-model="email" minlength="8" required /> </md-input-container>' +
                                                        '<br /><label style="width:200px"><h4 style="width:200px">Old Password&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </h4></label>' +
                                                    ' <md-input-container style="width: 40%;"><input type="password" name="password" ng-model="password"  minlength="8" required/> </md-input-container>' 
                            }
                            else {
                                    templatehtml = templatehtml + ' <md-input-container style="width: 40%;"><input type="email" name="email" placeholder="Enter your email" ng-model="email" minlength="8" ng-init="email=\'' + this.defaultemail + '\'" required /> </md-input-container>'
                            }
                            templatehtml = templatehtml + '<br /><label style="width:200px"><h4 style="width:200px">New Password&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </h4></label>' +
                                  ' <md-input-container style="width: 40%;"><input type="password" name="newpassword" ng-model="newpassword" minlength="8" required /> </md-input-container>' +
                                  '<br /><label style="width:200px"><h4 style="width:200px">Confirm Password : </h4></label>' +
                                  ' <md-input-container style="width: 40%;"><input type="password" name="confirmpassword" ng-model="confirmpassword" minlength="8" required /> </md-input-container>' +
                                  '<span style="color:red" ng-show="myForm.confirmpassword.$dirty">' +
                                    '<div ng-show="confirmpassword != newpassword">Confirm Password not matched</div>' +
                                  '</span>' +
                            '</md-dialog-content>' +
                      '  <md-dialog-actions>' +
                      '     <div style="color:{{color}}">{{message}}</div> ' +
                      '    <md-button ng-click="submitDialog()" class="md-primary" ng-disabled="myForm.$invalid || (confirmpassword != newpassword)" ng-class="{\'disableButton\': myForm.$invalid || (confirmpassword != newpassword)}">' +
                      '      Submit' +
                      '    </md-button>' +
                      '    <md-button ng-click="closeDialog()" class="md-primary">' +
                      '      Close' +
                      '    </md-button>' +
                      '  </md-dialog-actions>' +
                        '</form>' +
                        '</center>' +
                        '</md-dialog>';
            $scope.defaultemail = "";
            $mdDialog.show({
                parent: parentEl,
                title: 'Change Password',
                placeholder: 'Enter your email',
                targetEvent: $event,
                template:templatehtml,
                            locals: {
                                items: $scope.items
                            },
                            controller: DialogCntrChangePwd
                        });
        }





        $scope.forget1 = function (ev) {
            // Appending dialog to document.body to cover sidenav in docs app
            $scope.errordiv = false;
            var confirm = $mdDialog.prompt()
                .title('Forgot Password')
                .placeholder('Enter your email')
                .targetEvent(ev)
                .required(true)
                .ok('Okay!')
                .cancel('Cancel');
            $mdDialog.show(confirm).then(function (result) {
                //$scope.errordiv = true;
                $http({
                    method: 'Get',
                    url: 'Home/ForgetPassword?email=' + result,
                    ContentType: 'json',
                })
                    .then(function (data, status, headers, config) {
                        console.log(data.data)
                        if (data.data == "1") {
                            
                            $scope.errormsg = "Password sent on your registerd email.";
                            $scope.color = "green"
                            $scope.errordiv = true;
                        } else if (data.data == "0") {
                            $scope.$apply(function () {
                                $scope.errormsg = "Your email is invalid";
                                $scope.color = "red";
                                $scope.errordiv = true;
                            });
                        } else if (data.data == "2") {
                            $scope.color = "red";
                            $scope.errormsg = "There is problem in sending email. server mail is not configured";
                            $scope.errordiv = true;
                        }
                        console.log($scope.errordiv);
                    });

            }, function () {
                $scope.status = '';
            });
        };


        //if ($scope.paramContext != '') {
        //    if ($scope.paramContext == 'ADM')
        //        $location.path('/admin/login');
        //    else
        //        $location.path('/login');
        //} else {
        //    //appService.setAuth({ user: 'Anonymous', role: 'Anonymous', isAuth: true });
        //    $location.path('/login');
        //}
    });

})();
