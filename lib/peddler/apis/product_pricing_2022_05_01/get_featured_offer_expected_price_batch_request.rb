# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # The request body for the `getFeaturedOfferExpectedPriceBatch` operation.
      GetFeaturedOfferExpectedPriceBatchRequest = Structure.new do
        attribute?(:requests, [FeaturedOfferExpectedPriceRequest])
      end
    end
  end
end
