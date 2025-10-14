# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # The response associated with the `getListingOffersBatch` API call.
      GetListingOffersBatchResponse = Structure.new do
        # @return [Array<ListingOffersResponse>]
        attribute?(:responses, [ListingOffersResponse])
      end
    end
  end
end
