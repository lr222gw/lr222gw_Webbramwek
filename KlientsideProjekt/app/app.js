'use strict';

// Declare app level module which depends on views, and components
var app = angular.module('myApp', ['ngMap', 'ngRoute', 'angular-flash.service', 'angular-flash.flash-alert-directive', 'angular-jwt']);

app.controller('MapController', function($scope){
    var vm = this;

    var map;

    $scope.$on('mapInitialized', function(evt, evtMap){
       map = evtMap;
    });

    vm.markEventOnMap = function(event){
        if(myGlobals.currentMarker !== null){
            myGlobals.currentMarker.setMap(null);
        }

        var latlng = {
            lat:event.position.latitude,
            lng:event.position.longitude
        };
        console.log(latlng)

        myGlobals.currentMarker = new google.maps.Marker({position: latlng, map: map});

        map.panTo(latlng)
    }

});

app.controller('LoginController', function($http, $scope, $rootScope, flash, API){
    var vm = this;
    $rootScope.isLoggedIn = false;

    vm.login =function(){
        console.log($scope.email + $scope.password)
        var data = {'email' : $scope.email, 'password' : $scope.password};
            //Datan vi skickar med är anpassad efter vad vårt api kräver, i detta fall inloggningsuppgifter

        var url = API.baseUrl + "tags?" + API.apikey;
            //URLn som vi ska till på vårt api för att få tillbaka en inloggnings token (JWT)

        var config = {
            headers : {
                "X-APIkey" : API.apikey,
                "Accept" : "application/json" //responsedatan vi vill ha...
            }
        }

        var promise = $http.post(url, data, config); //skickar med datan vi strukturerat..

        promise.success(function(data, status, headers, config){

            //Funktionen som anropas om promise gick bra!
            $rootScope.token = data.auth_token;//gör nyckeln tillgänglig i programmet
            $rootScope.isLoggedIn = true; //isLoggedIn = true pga lyckad inlogg
            flash.success = "Inloggning lyckades";
        });
        promise.error(function(data, status, headers, config){
            $rootScope.token = "illegal token"; //ogiltig nyckel...
            $rootScope.isLoggedIn = false; //false pga misslyckad inlogg
        });
    }
});

app.directive("allEventsbox", function(){
    return {
        restrict: "E",
        templateUrl : "shared/event/allEventboxTemplate.html",
        controller : ["$http", "API", "$scope" , "flash", function($http, API, $scope, flash){
            var events = [];
            var activeEvent = {};
            var EventCtrl = this;
            var tags = [];

            var promise = $http.get(API.baseUrl + "events?" + API.apikey);

            promise.success(function(data){


                    flash.success = "Lyckad uppkoppling mot API!";

                EventCtrl.events = data.entries;

            });

            promise.error(function(data){
                flash.error = "Kunde inte komma åt API!";
                console.log(data);
            });

            var promise2 = $http.get( API.baseUrl + "tags?" + API.apikey);

            promise2.success(function(data){

                    flash.success = "Lyckad uppkoppling mot API!";

                EventCtrl.tags = data.entries;

            });

            promise2.error(function(data){
                console.log(data);
                flash.error = "Kunde inte komma åt API!";
            });

            this.setActiveEvent = function(event){
                EventCtrl.activeEvent = event;
            }

            this.setSearch = function(tag){
                if($scope.query !== undefined && $scope.query[0] === "#"){
                    $scope.query += ", #"+ tag.name;
                }else{
                    $scope.query = "#"+ tag.name;
                }
            }

            $scope.search = function (event){

                var name = event.name.toLowerCase();
                var posName = event.position.name.toLowerCase();
                var query =  $scope.query !== undefined ? $scope.query.toLowerCase() : "" ;
                var eventTags = [];

                for(var i = 0; i < event.tag_on_events.length; i++){
                    eventTags.push("#"+ event.tag_on_events[i].tag.name.toLowerCase())
                }
                var arrWithQueryTags = [];
                var severalQueryTrue = false
                if($scope.query !== undefined && $scope.query[0] === "#"){ //om det är en tagg vi kollar efter så kan det finnas flera...
                    arrWithQueryTags = $scope.query.split(", ");
                    console.log(arrWithQueryTags)

                    for(var i = 0; i < arrWithQueryTags.length; i++){
                        if(eventTags.indexOf(arrWithQueryTags[i].toLowerCase())!= -1){
                            severalQueryTrue = true;
                        }
                    }

                }

                if (name.search(query)!=-1 || posName.search(query)!=-1 || eventTags.indexOf(query) != -1 || severalQueryTrue) {

                    return true;
                }
                return false;
            };

        }],
        controllerAs: "eventCtrl"
    }
});


app.config(['$routeProvider', function($routeProvider) {
    $routeProvider.otherwise({redirectTo: '/view1'});
}]);

app.config(function(flashProvider){
    // Support bootstrap 3.0 "alert-danger" class with error flash types
    flashProvider.errorClassnames.push('alert-danger');

    /**
     * Also have...
     *
     * flashProvider.warnClassnames
     * flashProvider.infoClassnames
     * flashProvider.successClassnames
     */
});

app.constant("API", { //Inte bra att ha nyckeln på klienten egentligen
    'apikey' : "apikey=c2hpdHR5c2hpdHRlc3RAdGVzdC5zZSQyYSQxMCRtUWNObW03Z05WWkc3MFBZaXpaN0Mu",
    'baseUrl' : "http://127.0.0.1:3000/api/v1/"
});

var myGlobals = {
    currentMarker : null
};