'use strict';

// Declare app level module which depends on views, and components
var app = angular.module('myApp', ['ngMap', 'ngRoute']);

app.controller('MapController', function($scope){

    var vm = this;

    var map;

    $scope.$on('mapInitialized', function(evt, evtMap){
       map = evtMap;
    });

    vm.fillWithEvents = function(){

    };


});


app.config(['$routeProvider', function($routeProvider) {
    $routeProvider.otherwise({redirectTo: '/view1'});//DIDi
}]);