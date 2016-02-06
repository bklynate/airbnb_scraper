require 'open-uri'
require 'nokogiri'
require 'csv'
require 'pry'

url = "https://www.airbnb.com/s/Brooklyn--New-York--NY"
data = Nokogiri::HTML(open(url))

listing_names = []
data.css('h3.h5.listing-name').each do |listing|
  listing = listing.text
  listing = listing.delete("\n")
  listing = listing.strip
  listing_names << listing
end

listing_prices = []
data.css('span.h3.text-contrast.price-amount').each do |price|
  listing_prices << price.text
end

listing_details = []
data.css('div.text-muted.listing-location.text-truncate').each do |details|
  details = details.text
  details = details.delete("\n")
  listing_details << details
end
listing_details = listing_details.join.split(" ").join(" ").split("s ")

CSV.open("airbnb_listings.csv","w") do |file|
  listing_names.length.times do |i|
    file << [listing_names[i],listing_prices[i],listing_details[i]]
  end
end
