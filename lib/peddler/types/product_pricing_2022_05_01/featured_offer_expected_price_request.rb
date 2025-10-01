# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_2022_05_01/segment"

module Peddler
  module Types
    module ProductPricing20220501
      # An individual FOEP request for a particular SKU.
      FeaturedOfferExpectedPriceRequest = Structure.new do
        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String]
        attribute(:method, String)

        # @return [String]
        attribute(:sku, String)

        # @return [String] The URI associated with an individual request within a batch. For
        # `FeaturedOfferExpectedPrice`, this is `/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice`.
        attribute(:uri, String)

        # @return [Hash]
        attribute?(:body, Hash)

        # @return [Hash]
        attribute?(:headers, Hash)

        # @return [Segment]
        attribute?(:segment, Segment)
      end
    end
  end
end
