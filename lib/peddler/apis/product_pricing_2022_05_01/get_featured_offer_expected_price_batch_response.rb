# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The response schema for the `getFeaturedOfferExpectedPriceBatch` operation.
      GetFeaturedOfferExpectedPriceBatchResponse = Structure.new do
        # @return [Array<FeaturedOfferExpectedPriceResponse>]
        attribute?(:responses, [FeaturedOfferExpectedPriceResponse])
      end
    end
  end
end
