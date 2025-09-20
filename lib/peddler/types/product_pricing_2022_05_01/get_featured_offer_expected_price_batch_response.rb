# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/featured_offer_expected_price_response"

module Peddler
  module Types
    module ProductPricing20220501
      # The response schema for the `getFeaturedOfferExpectedPriceBatch` operation.
      GetFeaturedOfferExpectedPriceBatchResponse = Structure.new do
        # @return [Array<FeaturedOfferExpectedPriceResponse>]
        attribute(:responses, [FeaturedOfferExpectedPriceResponse])
      end
    end
  end
end
