var map;
var geocoder;

// This lines are filled by the fetchlocation.rb script
var center = 'REPLACE_ME';
var pins = {'replace': 'me'};

var markers = [];

function cacheStore(address, latLng) {
  var latLngCode = latLng !== null ? ('' + latLng.lat() + '|' + latLng.lng()) : null;
  localStorage.setItem('position_' + address, latLngCode);
}

function cacheLookup(address) {
  var cache = localStorage.getItem('position_' + address);
  if (cache === false || cache === null) return cache;

  var latLng = cache.split('|');
  return new google.maps.LatLng(parseFloat(latLng[0]), parseFloat(latLng[1]));
}

function withPositionFor(address, callback) {
  var result = cacheLookup(address);
  if (result === null) {
    geocoder.geocode({ address: address }, function(geocoderResults, error) {
      if (geocoderResults != null) {
        var firstResult = geocoderResults[0];
        var latLng = firstResult.geometry.location;
        cacheStore(address, latLng);
        callback(latLng)
      } else {
        cacheStore(address, false);
        console.log("not found", address, error);
      }
    });
  } else if (result !== false) {
    callback(result);
  }
}

function contentStringFor(location) {
  var firstLink = pins[location][0];
  return "<iframe width='1024' height='600' src='" + firstLink +"'></iframe>";
}

function insertMarkers() {
  var i = 0;
  for (var location in pins) {
    if (pins.hasOwnProperty(location)) {
      i = i + 1000;
      (function(location, links, delay) {
        setTimeout(function() {
          withPositionFor(location, function(latLng) {
            // var infowindow = new google.maps.InfoWindow({
            //   content: contentStringFor(closureLocation),
            //   maxWidth: 1200,
            // });

            var marker = new google.maps.Marker({
              position: latLng,
              map: map,
              title: 'Résulat (' + links.length + ') pour : ' + location,
            });

            google.maps.event.addListener(marker, 'click', function() {
              //infowindow.open(map,marker);
              var url = links[0];
              window.open(url, '_blank');
            });

            markers.push(marker);
          });
        }, delay);

      })(location, pins[location], i)
    }
  }
}

$(function(){
  geocoder = new google.maps.Geocoder();
  withPositionFor(center, function(latLng) {
    var options = { zoom: 8, center: latLng }
    map = new google.maps.Map(document.getElementById("map-canvas"), options);
    insertMarkers();
  });
});
