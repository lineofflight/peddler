# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The request body for the `getFeaturedOfferExpectedPriceBatch` operation.
      GetFeaturedOfferExpectedPriceBatchRequest = Structure.new do
        # @return [Array<FeaturedOfferExpectedPriceRequest>]
        attribute?(:requests, [FeaturedOfferExpectedPriceRequest])
      end
    end
  end
end
