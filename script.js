var map;
var geocoder;

// This lines are filled by the fetchlocation.rb script
var center = 'REPLACE_ME';
var pins = {'replace': 'me'};

function centerArea(geocoderResults) {
  var firstResult = geocoderResults[0];
  var options = {
    zoom: 8,
    center: firstResult.geometry.location,
  }
  map = new google.maps.Map(document.getElementById("map-canvas"), options);
}

$(function(){
  geocoder = new google.maps.Geocoder();
  geocoder.geocode({ address: center, }, centerArea);
});

