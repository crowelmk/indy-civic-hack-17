(function () {
    var app = angular.module('civichack17App', ['DataManager', 'ui.router', 'chart.js', 'rzModule', 'angular-centered']);
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
