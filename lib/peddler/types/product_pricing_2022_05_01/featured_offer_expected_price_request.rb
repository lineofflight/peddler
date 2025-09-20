# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/http_headers"
require "peddler/types/product_pricing_2022_05_01/segment"

module Peddler
  module Types
    module ProductPricing20220501
      # An individual FOEP request for a particular SKU.
      FeaturedOfferExpectedPriceRequest = Structure.new do
        # @return [String] The URI associated with an individual request within a batch. For
        # `FeaturedOfferExpectedPrice`, this is `/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice`.
        attribute(:uri, String)

        # @return [String]
        attribute(:method, String)

        # @return [Hash]
        attribute(:body, Hash)

        # @return [HttpHeaders]
        attribute(:headers, HttpHeaders)

        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String]
        attribute(:sku, String)

        # @return [Segment]
        attribute(:segment, Segment)
      end
    end
  end
end
