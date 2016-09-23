require "json"
require "sinatra/base"
require "geocoin"

LOCATOR = Geocoin::CityLocator.new

class GeocoinApp < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/' do
    @url = params[:u]
    @api_key = params[:k]
    @page_limit = (params[:p] || 3).to_i
    @region = (params[:r] || 'France')
    @location_map = compute_location_map(@url, @page_limit)

    erb :index
  end

  private

  def compute_location_map(url, page_limit)
    results = Geocoin::Search.new(url: url, page_limit: page_limit).results
    results.map! { |hash| Geocoin::SearchResult.new(hash) }
    results.each { |search_result| search_result.set_coordinates(LOCATOR) }
    results = results.group_by(&:location)
    orphans = results.delete(nil) || []
    orphans = orphans.group_by { |search_result| search_result.city.join(", ") }
    results.merge!(orphans) { |_, oldval, newval| oldval + newval }
  end
end
