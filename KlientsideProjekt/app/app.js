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

app.controller('LoginController', function($http, $scope, $rootScope, flash, API, jwtHelper){
    var vm = this;
    $rootScope.isLoggedIn = localStorage["loggedIn"] !==  false ? localStorage["loggedIn"] : false;

    vm.isOnline = function(){
        return $rootScope.isLoggedIn;
    }
    vm.logout =function() {
        $rootScope.isLoggedIn = false;
        $rootScope.token = "illegal token";
        localStorage["loggedIn"] = false;
        localStorage["jwtToken"] = "illegal token";
        localStorage["userId"] = null;
        flash.success = "Utloggning lyckades!";
    }

    vm.login =function(){
        console.log($scope.email + $scope.password)
        var data = {'email' : $scope.email, 'password' : $scope.password}; //VET INTE HUR MAN KOMMER ÅT DATA FRÅN SERVERN SEN!!!!!
            //Datan vi skickar med är anpassad efter vad vårt api kräver, i detta fall inloggningsuppgifter

        var url = API.baseUrl + "login?" + API.apikey;
            //URLn som vi ska till på vårt api för att få tillbaka en inloggnings token (JWT)

        var config = {
            headers : {
                "X-APIkey" : API.apikey,
                "Accept" : "application/json", //responsedatan vi vill ha...
                'email' : $scope.email, 'password' : $scope.password
            }
        }

        var promise = $http.post(url, data, config); //skickar med datan vi strukturerat..

        promise.success(function(data, status, headers, config){
            console.log(data)
            //Funktionen som anropas om promise gick bra!
            $rootScope.token = data.jwt;//gör nyckeln tillgänglig i programmet
            $rootScope.isLoggedIn = true; //isLoggedIn = true pga lyckad inlogg
            flash.success = "Inloggning lyckades!";
            localStorage["loggedIn"] = true;
            localStorage["userId"] = jwtHelper.decodeToken(data.jwt).user_id;
            localStorage["jwtToken"] = data.jwt;

        });
        promise.error(function(data, status, headers, config){
            $rootScope.token = "illegal token"; //ogiltig nyckel...
            $rootScope.isLoggedIn = false; //false pga misslyckad inlogg
            console.log(data)
            flash.error = data.error;
            localStorage["loggedIn"] = false;
            localStorage["userId"] = null;
            localStorage["jwtToken"] = "illegal token";
        });
    }
});

app.directive("allEventsbox", function(){
    return {
        restrict: "E",
        templateUrl : "shared/event/allEventboxTemplate.html",
        controller : ["$http", "API", "$scope" , "flash", "$filter", function($http, API, $scope, flash, $filter){
            var events = [];
            var activeEvent = {};

            var EventCtrl = this;
            var tags = [];
            this.prevEvent = null;


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
                if(myGlobals.eventToEdit !== undefined){
                    if( myGlobals.eventToEdit.id !== event.id){
                        $scope.editMode = false;
                    }
                }else{$scope.editMode = false;}

                EventCtrl.activeEvent = event;


            }
            this.saveEdit = function(){
                var eventToEdit = myGlobals.eventToEdit;
                eventToEdit.name = $scope.eventName;
                eventToEdit.eventDate = $scope.date;
                eventToEdit.desc = $scope.desc;
                eventToEdit.position.name = $scope.positionName;
                eventToEdit.name = $scope.eventName;
                eventToEdit.tags = $scope.tags;
                var data = {
                    event: eventToEdit
                }

                myGlobals.eventToEdit = undefined;

                var config = {
                    headers : {
                        "X-APIkey" : API.apikey,
                        "Accept" : "application/json", //responsedatan vi vill ha...
                        'Authorization' : localStorage["jwtToken"]
                    }
                }

                var promise = $http.put(API.baseUrl+"uppdateExtra?"+API.apikey, data, config)

                promise.success(function(){
                    flash.success ="Ändringarna sparades"



                    var promise = $http.get(API.baseUrl + "events?" + API.apikey);

                    promise.success(function(data){

                        flash.success = "Lyckad uppkoppling mot API!";

                        EventCtrl.events = data.entries;
                        $scope.editMode = false
                    });

                    promise.error(function(data){
                        flash.error = "Kunde inte komma åt API!";
                        console.log(data);
                    });
                })

                promise.error(function(){
                    flash.error ="Något blev fel"
                })

            }

            this.getTags = function(event){
                var tagsArr= [];
                for(var i = 0; i < event.tag_on_events.length; i++){
                    tagsArr.push(event.tag_on_events[i].tag.name);
                }

                var arrayString = tagsArr.join(", ");
                return arrayString;

            }

            this.setSearch = function(tag){
                if($scope.query !== undefined && $scope.query[0] === "#"){
                    $scope.query += ", #"+ tag.name;
                }else{
                    $scope.query = "#"+ tag.name;
                }
            }

            this.setEditMode = function(mode, event){
                $scope.editMode = mode;
                if(event !== undefined){
                    if(event !== null){
                        myGlobals.eventToEdit = event;

                        $scope.eventName = event.name
                        $scope.tags = this.getTags(event)
                        $scope.desc = event.desc
                        $scope.positionName = event.position.name
                        $scope.date = $filter("date")(event.eventDate,  'yyyy-MM-dd')
                    }
                }
            }

            this.currentUserOwnsEvent = function(event){
                /*console.log("events Users ID = "+ event.user_id.toString())
                console.log("user Id = "+ localStorage['userId'])*/
                return event.user_id.toString() === localStorage['userId'];
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
    currentMarker : null,
    eventToEdit : undefined
};