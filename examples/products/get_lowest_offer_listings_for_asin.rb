require File.expand_path('../../share.rb', __FILE__)

res = @client.get_lowest_offer_listings_for_asin '0143105825'

binding.pry
