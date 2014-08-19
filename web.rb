require 'json'
require 'nokogiri'
require 'open-uri'
require 'sinatra/base'

class Geocoin < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/' do
    @api_key = params[:k]
    @url_prefix = params[:u]
    @page_count = (params[:p] || 3).to_i
    @region = (params[:r] || 'France')
    @location_map = compute_location_map(@url_prefix, @page_count)

    erb :index
  end

  private

  def compute_location_map(url_prefix, page_count)
    location_map = {}
    page_count.times do |i|
      url = url_prefix + "&o=#{i + 1}"
      doc = Nokogiri::HTML(open(url))
      doc.css('.list-lbc > a').each do |item|
        offer = {
          url:   item.attr('href'),
          price: ((price = item.css('.price').first) && price.content.strip),
          label: item.css('.title').first.content.strip,
          date:  item.css('.date div').map{ |item| item.content.strip }.join(' '),
          img:   ((image = item.css('.image img').first) && image.attr('src')),
        }

        # Add the offer to the location
        location = item.css('.placement').first.content
        location = location.split('/').map(&:strip).join(', ')
        (location_map[location] ||= []) << offer
      end
    end
    location_map
  end
end
