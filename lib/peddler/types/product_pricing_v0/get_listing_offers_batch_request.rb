# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_v0/listing_offers_request"

module Peddler
  module Types
    module ProductPricingV0
      # The request associated with the `getListingOffersBatch` API call.
      GetListingOffersBatchRequest = Structure.new do
        # @return [Array<ListingOffersRequest>]
        attribute(:requests, [ListingOffersRequest])
      end
    end
  end
end
