# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # The request associated with the `getListingOffersBatch` API call.
      GetListingOffersBatchRequest = Structure.new do
        # @return [Array<ListingOffersRequest>]
        attribute?(:requests, [ListingOffersRequest])
      end
    end
  end
end
