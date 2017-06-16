(function () {
    var app = angular.module('civichack17App', ['DataManager', 'ui.router', 'chart.js', 'rzModule', 'angular-centered']);


    // app.run(function ($state, $rootScope) {
    //     $rootScope.$on('$stateChangeError', function (evt, toState, toParams, fromState, fromParams, error) {
    //         if (angular.isObject(error) && angular.isString(error.code)) {
    //             switch (error.code) {
    //                 case 'NOT_AUTH':
    //                     // go to the login page
    //                     $state.go('home');
    //                     break;
    //                 case 'ALREADY_AUTH':
    //                     //go to the dash board
    //                     $state.go('user.history');
    //                     break;
    //                 default:
    //                     // set the error object on the error state and go there
    //                     $state.get('error').error = error;
    //                     $state.go('error');
    //             }
    //         }
    //         else {
    //             // unexpected error
    //             $state.go('home');
    //         }
    //     });
    // });
    app.config(function ($stateProvider, $urlRouterProvider) {//, $locationProvider) {
        // $locationProvider.html5Mode(true);

        $urlRouterProvider.otherwise('/');
        $stateProvider
            .state('home', {
                url: '/',
                abstract: false,
                templateUrl: '/views/home.html',
                controller: 'homeCtrl',
                controllerAs: 'home'
            });

    });

    app.exports = app;
})();
