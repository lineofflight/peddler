# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The parameters for an individual request.
      FeaturedOfferExpectedPriceRequestParams = Structure.new do
        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String]
        attribute(:sku, String)

        # @return [Segment]
        attribute?(:segment, Segment)
      end
    end
  end
end
