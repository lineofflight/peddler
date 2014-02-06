require 'mws/products/parsers/offer_listing_for_sku'
require 'peddler/parsers/collection'

module MWS
  module Products
    module Parsers
      class OfferListingsForSKU < ::Peddler::Parsers::Collection
        def each(&blk)
          document.each { |node| yield OfferListingForSKU.new(node) }
        end
      end
    end
  end
end
