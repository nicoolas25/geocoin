require "csv"

# This class use a CSV to map city names to GPS coordinates.
# The CSV is expected to have the following format:
#   - No headers
#   - Separated by commas
#   - Columns: Name of the city, Zipcode, Latitude, Longitude
#   - If a city have multiple zipcode, they are separated by '-'
#   - Zipcodes are String objects
module Geocoin
  class CityLocator
    def initialize(filename: "communes.csv")
      @filename = filename
    end

    def coords(name)
      transformation_strategies.each do |strategy|
        new_name = strategy.call(name.dup)
        next unless new_name
        coords = strict_coords(new_name)
        return coords + [new_name] if coords
      end
      nil
    end

    private

    def strict_coords(name)
      result = mapping.fetch(name, [])
      result.size == 1 && result.first
    end

    def transformation_strategies
      [
        # Use original name
        Proc.new { |name| name },
        # Paris districts
        Proc.new { |name| name =~ /^Paris \d+ème$/ && "Paris" },
      ]
    end

    def mapping
      @mapping ||= {}.tap do |mapping|
        ::CSV.foreach(@filename) do |row|
          name = row[0]
          zipcodes = row[1]
          lat = row[2].to_f
          long = row[3].to_f
          (mapping[name] ||= []) << [lat, long]
        end
      end
    end
  end
end
