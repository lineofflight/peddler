# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_2022_05_01/featured_offer_expected_price_request"

module Peddler
  module Types
    module ProductPricing20220501
      # The request body for the `getFeaturedOfferExpectedPriceBatch` operation.
      GetFeaturedOfferExpectedPriceBatchRequest = Structure.new do
        # @return [Array<FeaturedOfferExpectedPriceRequest>]
        attribute(:requests, [FeaturedOfferExpectedPriceRequest])
      end
    end
  end
end
