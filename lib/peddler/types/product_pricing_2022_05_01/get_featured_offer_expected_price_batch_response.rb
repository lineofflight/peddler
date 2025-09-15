# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricing20220501
      # The response schema for the `getFeaturedOfferExpectedPriceBatch` operation.
      GetFeaturedOfferExpectedPriceBatchResponse = Structure.new do
        # @return [Array<FeaturedOfferExpectedPriceResponse>]
        attribute(:responses, Array)
      end
    end
  end
end
