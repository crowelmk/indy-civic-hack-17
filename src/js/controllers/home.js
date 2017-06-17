'use strict';

/**
 * @ngdoc function
 * @name civichack17App.controller:UserCtrl
 * @description
 * # UserCtrl
 * Controller of the civichack17App
 */
angular.module('civichack17App')
  .controller('homeCtrl', ['$scope', '$http', function ($scope, $http) {
    $('.menu .item')
      .tab()
    ;
  }]);
