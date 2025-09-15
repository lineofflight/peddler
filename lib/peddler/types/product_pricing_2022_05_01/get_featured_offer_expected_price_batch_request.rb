# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricing20220501
      # The request body for the `getFeaturedOfferExpectedPriceBatch` operation.
      GetFeaturedOfferExpectedPriceBatchRequest = Structure.new do
        # @return [Array<FeaturedOfferExpectedPriceRequest>]
        attribute(:requests, Array)
      end
    end
  end
end
