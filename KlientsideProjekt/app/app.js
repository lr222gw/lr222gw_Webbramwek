'use strict';

// Declare app level module which depends on views, and components
var app = angular.module('myApp', ['ngMap', 'ngRoute', 'angular-flash.service', 'angular-flash.flash-alert-directive', 'angular-jwt']);

app.controller('MapController', function($scope, flash){
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
        if(event.position.latitude !== null && event.position.longitude !== null){
            myGlobals.currentMarker = new google.maps.Marker({position: latlng, map: map});
            flash.success = "Hittade eventet på kartan"
            flash.error = ""
        }else{
            flash.error = "Eventet är sparat med ogiltig position, vänligen ändra positionsnamnet (om det är ditt event)"
        }


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
            flash.error = "";
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

app.controller('EventController',
    ["$http", "API", "$scope" , "flash", "$filter", "$rootScope", '$routeParams', '$location',
    function($http, API, $scope, flash, $filter, $rootScope, $routeParams, $location){

    var events = [];
    var activeEvent = {};
    var EventCtrl = this;
    var tags = [];
    this.prevEvent = null;

    var promise = $http.get(API.baseUrl + "events?" + API.apikey);

    promise.success(function(data){

        flash.success = "Lyckad uppkoppling mot API!";

        EventCtrl.events = data.entries;
        EventCtrl.checkParams();
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

    this.checkParams = function(){
        if($routeParams.id !== undefined){
            console.log($routeParams.id)
            console.log($routeParams)

            for(var i = 0; i < EventCtrl.events.length; i++){

                /*console.log(EventCtrl.events[i].id)
                console.log($routeParams.id)*/
                if(EventCtrl.events[i].id.toString() === $routeParams.id.toString()){
                    EventCtrl.activeEvent = EventCtrl.events[i];
                }
            }

        }
    }

    this.setActiveEvent = function(event){
        $scope.createMode = false;
        if(myGlobals.eventToEdit !== undefined){
            if( myGlobals.eventToEdit.id !== event.id){
                $scope.editMode = false;
            }
        }else{$scope.editMode = false;}

        EventCtrl.activeEvent = event;
        $rootScope.activeEvent = event
        $location.url('/event/' + event.id)

    }
    this.deleteEvent = function(){
        if(confirm("Är du helt säker på att du vill radera skiten?")){
            var eventToEdit = myGlobals.eventToEdit;
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

            var promise = $http.delete(API.baseUrl+"events/"+eventToEdit.id+"?"+API.apikey, config)

            promise.success(function(){

                EventCtrl.updateLists()
            });
            promise.error(function(){

            });
        }
    }

    this.createEventStatus = function(){
        $scope.createMode= true;
        $scope.editMode= false;
        EventCtrl.activeEvent = undefined;
    }
    this.updateLists = function(){

        var promise = $http.get(API.baseUrl + "events?" + API.apikey);

        promise.success(function(data){
            EventCtrl.events = [];
            //flash.success = "Lyckad uppkoppling mot API!";

            EventCtrl.events = data.entries;
            $scope.editMode = false
        });

        promise.error(function(data){
            flash.error = "Kunde inte komma åt API!";
            console.log(data);
        });
    }
    this.saveEvent = function(){

        console.log($scope.eventName)
        var event = {};
        if($scope.eventName !== undefined && $scope.eventName !== ""){
            event.name =$scope.eventName;
        }else{

            flash.error = "Du måste ange ett namn till eventet"

            return}

        console.log($scope.positionName)
        if($scope.positionName !== undefined && $scope.positionName !== ""){
            event.position = {}
            event.position.name =$scope.positionName;

        }else{
            flash.error = "Du måste ange ett namn till platsen"
            return}

        console.log($scope.date)
        if($scope.date !== undefined && $scope.date !== ""){

            event.eventDate =$scope.date;

        }else{
            flash.error = "Du måste ange ett datum för fasiken"
            return}

        console.log($scope.desc)
        if($scope.desc !== undefined && $scope.desc !== ""){
            event.desc =$scope.desc;
        }else{
            flash.error = "Ange en beskrivning. Hur ska folk annars fatta?"
            return}
        event.tags =$scope.tags;
        flash.error = "";

        console.log($scope.tagg)

        var data = {
            event: event
        }

        myGlobals.eventToEdit = undefined;

        var config = {
            headers : {
                "X-APIkey" : API.apikey,
                "Accept" : "application/json", //responsedatan vi vill ha...
                'Authorization' : localStorage["jwtToken"]
            }
        }

        var promise = $http.post(API.baseUrl+"createExtra?"+API.apikey, data, config);

        promise.success(function(){
            flash.success ="Eventet sparades"

            EventCtrl.updateLists()
        })

        promise.error(function(){
            flash.error ="Eventet sparades inte som det skulle, logga ut sen logga in och gör om..."
        })


    }
    this.saveEdit = function(){
        var eventToEdit = myGlobals.eventToEdit;
        eventToEdit.name = $scope.eventName;
        eventToEdit.eventDate = $scope.date;
        eventToEdit.desc = $scope.desc;
        eventToEdit.position.name = $scope.positionName;
        //eventToEdit.name = $scope.eventName;
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
            EventCtrl.updateLists()

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
        if(event !== undefined){
            return event.user_id.toString() === localStorage['userId'];
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
            console.log(arrWithQueryTags);

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

}]);

app.directive("allEventsbox", function(){
    return {
        restrict: "E",
        templateUrl : "shared/event/allEventboxTemplate.html",
        controller : 'EventController',
        controllerAs: "eventCtrl"
    }
});

app.controller('EventUrlController', ['$routeParams', '$rootScope',function($routeParams, $rootScope){
    alert()
    var id = $routeParams.id;
    console.log("yolo" )
    //$rootScope.activeEvent
}]);

app.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    var UrlFix = "";//"/app";//'/klientapp2'; // Se till att du kommer in på appen via URLn http://127.0.0.1/klientapp2/
                                    //Om du kommer in på appen genom http://127.0.0.1/ så kan di ändra UrlFix till bara ""...
    $routeProvider.when(UrlFix+'/',{

    }).when(UrlFix+'/cool',{
        template: "<div>This is my cool crib</div>"
    }).when(UrlFix+'/lame',{
        template: "<div>this is my lame crib :(</div>"
    }).when('/event/:id',{
        controller: 'EventController'
    }).otherwise({
        redirectTo: '/' //<div><strong>Det finns ingenting här, gå tillbaka... :)</strong></div>
    });

    //html5Mode(true) <- krånglade...
    //$locationProvider.html5Mode(true);
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
    'apikey' : "apikey=Q29vbEFwcGlvdGVzdEB0ZXN0LnNlJDJhJDEwJEhaY0ptMFI5NnZVYnZraGJqQS90VmU=",
    'baseUrl' : "http://127.0.0.1:3000/api/v1/"
});

var myGlobals = {
    currentMarker : null,
    eventToEdit : undefined
};