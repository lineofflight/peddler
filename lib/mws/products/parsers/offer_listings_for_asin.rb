require 'mws/products/parsers/offer_listing_for_asin'
require 'peddler/parsers/collection'

module MWS
  module Products
    module Parsers
      class OfferListingsForASIN < ::Peddler::Parsers::Collection
        def each(&blk)
          document.each { |node| yield OfferListingForASIN.new(node) }
        end
      end
    end
  end
end
