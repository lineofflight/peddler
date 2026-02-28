# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # An individual FOEP request for a particular SKU.
      FeaturedOfferExpectedPriceRequest = Structure.new do
        # @return [String]
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String]
        attribute(:method, String, null: false)

        # @return [String]
        attribute(:sku, String, null: false)

        # @return [String] The URI associated with an individual request within a batch. For
        #   `FeaturedOfferExpectedPrice`, this is `/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice`.
        attribute(:uri, String, null: false)

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
