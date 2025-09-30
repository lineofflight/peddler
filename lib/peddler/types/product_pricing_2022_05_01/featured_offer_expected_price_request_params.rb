# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_2022_05_01/segment"

module Peddler
  module Types
    module ProductPricing20220501
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
