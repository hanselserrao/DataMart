function functionToRunWhenReady(id) {
    angular.element(document).ready(function () {
        var scope = angular.element($('#input_2_id')).scope();
        scope.$apply(function () {
            scope.documentNumber = id;
            localStorage.setItem('docnumber', id);
            var readyStateCheckInterval = setInterval(function () {
                if (document.readyState === "complete") {
                    clearInterval(readyStateCheckInterval);
                    angular.element('.dcobtn').triggerHandler('click');
                }
            }, 2000);
        });
    });
}


function PartSearchToRunWhenReady(id) {
    angular.element(document).ready(function () {
        var scope = angular.element($('#input_part_id')).scope();
        scope.$apply(function () {
            scope.partNumber = id;
            localStorage.setItem('partnumber', id);
            var readyStateCheckInterval = setInterval(function () {
                if (document.readyState === "complete") {
                    clearInterval(readyStateCheckInterval);
                    angular.element('.partbtn').triggerHandler('click');
                }
            }, 2000);
        });
    });
}


function LEDSearchToRunWhenReady(id) {
    angular.element(document).ready(function () {
        var scope = angular.element($('#input_led_id')).scope();
        scope.$apply(function () {
            scope.liftpartNumber = id;
            localStorage.setItem('liftpartNumber', id);
            var readyStateCheckInterval = setInterval(function () {
                if (document.readyState === "complete") {
                    clearInterval(readyStateCheckInterval);
                    angular.element('.ledbtn').triggerHandler('click');
                }
            }, 2000);
        });
    });
}

function PCNSearchToRunWhenReady(id) {
    angular.element(document).ready(function () {
        var scope = angular.element($('#input_pcn_id')).scope();
        scope.$apply(function () {
            scope.pcnNumber = id;
            localStorage.setItem('pcnNumber', id);
            var readyStateCheckInterval = setInterval(function () {
                if (document.readyState === "complete") {
                    clearInterval(readyStateCheckInterval);
                    angular.element('.pcnbtn').triggerHandler('click');
                }
            }, 2000);
        });
    });
}

function ETOSearchToRunWhenReady(id) {
    angular.element(document).ready(function () {
        var scope = angular.element($('#input_eto_id')).scope();
        scope.$apply(function () {
            scope.etoNumber = id;
            localStorage.setItem('etoNumber', id);
            var readyStateCheckInterval = setInterval(function () {
                if (document.readyState === "complete") {
                    clearInterval(readyStateCheckInterval);
                    angular.element('.etobtn').triggerHandler('click');
                }
            }, 2000);
        });
    });
}