require 'peddler/parsers/xml'

module MWS
  module Products
    module Parsers
      class Product < ::Peddler::Parsers::XML

        def identifiers
          Identifiers.new(xpath('Identifiers'))
        end

        def lowest_offer_listings
          LowestOfferListings.new(xpath('LowestOfferListings'))
        end

      end
    end
  end
end
