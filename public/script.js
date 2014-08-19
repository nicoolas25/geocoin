var map, geocoder, markers = [];

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

function fillResultsWith(offers) {
  $('#results').html('');
  var buffer = '';
  for (var offer in offers) {
    offer = offers[offer]

    buffer += '<a class="offer" href="' + offer.url + '" target="_blank">';
    buffer += '<div class="left">';
    buffer += '<div class="image">';
    if (offer.img) buffer += '<img src="' + offer.img + '">';
    buffer += '</div>';
    buffer += '</div>';
    buffer += '<div class="right">';
    buffer += '<div class="label">' + offer.label + '</div>';
    buffer += '<div class="price">' + offer.price + '</div>';
    buffer += '<div class="date">' + offer.date + '</div>';
    buffer += '</div>';
    buffer += '</a>';
  }
  $('#results').html(buffer);
}

function insertMarkers() {
  var i = 0;
  for (var location in pins) {
    if (pins.hasOwnProperty(location)) {
      i = i + 1000;
      (function(location, offers, delay) {
        setTimeout(function() {
          withPositionFor(location, function(latLng) {
            var marker = new google.maps.Marker({
              position: latLng,
              map: map,
              title: 'Résulat (' + offers.length + ') pour : ' + location,
            });

            google.maps.event.addListener(marker, 'click', function() {
              fillResultsWith(offers);
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
