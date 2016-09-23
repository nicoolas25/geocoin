module Geocoin
  class SearchResult
    attr_reader :url, :label, :price, :date, :city, :img, :lat, :lng, :location

    def initialize(attrs = {})
      attrs.each { |name, value| instance_variable_set("@#{name}", value) }
    end

    def set_coordinates(locator)
      @lat, @lng, @location = locator.coords(city.first)
    end

    def to_json(*_)
      {
        url: url,
        label: label,
        price: price,
        date: date,
        city: city.join(" / "),
        img: img,
        lat: lat,
        lng: lng,
      }.to_json
    end
  end
end
