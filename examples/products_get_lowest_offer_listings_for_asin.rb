$:.unshift File.expand_path('../../lib', __FILE__)

require 'pry'
require 'yaml'
require 'peddler/products'

req = Peddler::Products.new 'DE'
req.configure YAML.load_file File.expand_path '../amazon.yml', __FILE__

res = req.get query: { 'Action'          => 'GetLowestOfferListingsForASIN',
                       'ASINList.ASIN.1' => '0195019199',
                       'MarketplaceId'   => req.marketplace }

binding.pry
