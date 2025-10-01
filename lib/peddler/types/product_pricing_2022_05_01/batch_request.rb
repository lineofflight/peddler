# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_2022_05_01/http_headers"

module Peddler
  module Types
    module ProductPricing20220501
      # The common properties for individual requests within a batch.
      BatchRequest = Structure.new do
        # @return [String]
        attribute(:method, String)

        # @return [String] The URI associated with an individual request within a batch. For
        # `FeaturedOfferExpectedPrice`, this is `/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice`.
        attribute(:uri, String)

        # @return [Hash]
        attribute?(:body, Hash)

        # @return [HttpHeaders]
        attribute?(:headers, HttpHeaders)
      end
    end
  end
end
