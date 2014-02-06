require 'mws/products/parsers/identifiers'
require 'mws/products/parsers/lowest_offer_listings'
require 'peddler/parsers/model'

module MWS
  module Products
    module Parsers
      class Product < ::Peddler::Parsers::Model
        value :identifiers do
          Identifiers.new(xpath('Identifiers'))
        end

        value :lowest_offer_listings do
          LowestOfferListings.new(xpath('LowestOfferListings'))
        end
      end
    end
  end
end
