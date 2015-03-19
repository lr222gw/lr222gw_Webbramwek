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

/*app.controller("EventController", ["$http", "API",function($http, API){

    var events = {};
    var EventCtrl = this;

    var promise = $http.get("http://127.0.0.1:3000/api/v1/events?" + API.apikey);

    promise.success(function(data){
        EventCtrl.events = data.entries;
        console.log(EventCtrl.events)
    });

    promise.error(function(data){
        console.log(data);
    });

}]);*/

app.directive("allEventsbox", function(){
    return {
        restrict: "E",
        templateUrl : "shared/event/allEventboxTemplate.html",
        controller : ["$http", "API",function($http, API){
            var events = {};
            var EventCtrl = this;

            var promise = $http.get("http://127.0.0.1:3000/api/v1/events?" + API.apikey);

            promise.success(function(data){
                EventCtrl.events = data.entries;
                console.log(EventCtrl.events)
            });

            promise.error(function(data){
                console.log(data);
            });
        }],
        controllerAs: "eventCtrl"
    }
});


app.config(['$routeProvider', function($routeProvider) {
    $routeProvider.otherwise({redirectTo: '/view1'});//DIDi
}]);

app.constant("API", { //Inte bra att ha nyckeln på klienten egentligen
    'apikey' : "apikey=dGVzdHRlc3RAdGVzdC5zZSQyYSQxMCRDYXNSd29JN2FuTC41RklRaDJBTGNP"
});