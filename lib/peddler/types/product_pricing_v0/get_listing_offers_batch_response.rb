# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_v0/listing_offers_response"

module Peddler
  module Types
    module ProductPricingV0
      # The response associated with the `getListingOffersBatch` API call.
      GetListingOffersBatchResponse = Structure.new do
        # @return [Array<ListingOffersResponse>]
        attribute?(:responses, [ListingOffersResponse])
      end
    end
  end
end
