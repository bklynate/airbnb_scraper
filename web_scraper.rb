require 'open-uri'
require 'nokogiri'
require 'csv'
require 'pry'

# Url that is to be scraped
url = "https://www.airbnb.com/s/Brooklyn--New-York--NY"

# Parse the HTML with nokogiri
data = Nokogiri::HTML(open(url))

# Scrapes the listing names into arrays
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

# Had to strip the extra whitespace within the strings in the array
# binding.pry <- uncomment if you dont understand
listing_details = listing_details.join.split(" ").join(" ").split("s ")

# Write the csv file with the scraped data
CSV.open("airbnb_listings.csv","w") do |file|
  # add header to data columns
  file <<  ["Listing Names", "Listing Prices", "Listing Details"]

  listing_names.length.times do |i|
    file << [listing_names[i],listing_prices[i],listing_details[i]]
  end
end
