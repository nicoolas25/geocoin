require "rack"
require "uri"
require "open-uri"
require "nokogiri"

module Geocoin
  class Search
    def initialize(url:, page_limit: 1)
      @url = URI(url)
      @page_limit = page_limit
    end

    def results
      (1..@page_limit).each_with_object([]) do |page_number, results|
        results.concat fetch_offers(page_number)
      end
    end

    private

    DEFAULT_IMG = "//static.leboncoin.fr/img/no-picture.png".freeze
    OFFER_SEL = "section.tabsContent.block-white.dontSwitch > ul > li > a.list_item".freeze
    TITLE_SEL = "section.item_infos h2.item_title".freeze
    PRICE_SEL = "section.item_infos h3.item_price".freeze
    DATE_XSEL = "section/aside/p/text()".freeze
    CITY_XSEL = "section/p[@class=\"item_supp\"][2]".freeze
    IMG_SEL = ".item_image .item_imagePic span".freeze

    def fetch_offers(page_number)
      doc = crawl(page_number)
      doc.css(OFFER_SEL).each_with_object([]) do |li, results|
        results << {
          url: li.attr("href"),
          label: li.css(TITLE_SEL).first.content.strip,
          price: (price = li.css(PRICE_SEL).first) ? price.content.strip : "",
          date: li.xpath(DATE_XSEL).last.content.strip,
          city: li.xpath(CITY_XSEL).first.content.split("/").map(&:strip),
          img: (img = li.css(IMG_SEL).first) ? img.attr("data-imgsrc") : DEFAULT_IMG,
        }
      end
    end

    def url_for_page(page_number)
      @url.dup.tap do |url|
        query = Rack::Utils.parse_query(url.query)
        query["o"] = page_number
        url.query = Rack::Utils.build_query(query)
      end
    end

    def crawl(page_number)
      url = url_for_page(page_number)
      Nokogiri::HTML(open(url))
    end
  end
end
