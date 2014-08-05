require 'json'
require 'nokogiri'
require 'open-uri'
require 'dotenv'
Dotenv.load

SCRIPT_INPUT  = 'script.js'.freeze
HTML_INPUT    = 'showlocation.html'.freeze
SCRIPT_OUTPUT = 'build/script.js'.freeze
HTML_OUTPUT   = 'build/showlocation.html'.freeze

page_count = ARGV[0].to_i
region     = ARGV[1]
url_prefix = ARGV[2]

location_map = {}
page_count.times do |i|
  url = url_prefix + "&o=#{i + 1}"
  doc = Nokogiri::HTML(open(url))
  doc.css('.list-lbc > a').each do |item|
    location = item.css('.placement').first.content
    location = location.split('/').map(&:strip).join(', ')
    link     = item.attr('href')
    (location_map[location] ||= []) << link
  end
end

# Output the script
content = File.read(SCRIPT_INPUT)
new_content = content.
  sub(/^var center = .*$/, "var center = '#{region}';").
  sub(/^var pins = .*$/, "var pins = #{JSON.generate(location_map)};")
File.open(SCRIPT_OUTPUT, 'w') { |f| f.write(new_content) }

# Output the HTML
content = File.read(HTML_INPUT)
new_content = content.sub(/__API_KEY__/, ENV['GEOCOIN_KEY'])
File.open(HTML_OUTPUT, 'w') { |f| f.write(new_content) }
