require 'peddler/parsers/collection'
require 'mws/products/parsers/lowest_offer_listing'

module MWS
  module Products
    module Parsers
      class LowestOfferListings < ::Peddler::Parsers::Collection

        def each(&blk)
          lowest_offer_listing_nodes.each { |node| yield LowestOfferListing.new(node) }
        end

        private

        def lowest_offer_listing_nodes
          xpath('LowestOfferListing')
        end

      end
    end
  end
end
