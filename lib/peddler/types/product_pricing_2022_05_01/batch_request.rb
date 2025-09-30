# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_2022_05_01/http_headers"

module Peddler
  module Types
    module ProductPricing20220501
      # The common properties for individual requests within a batch.
      BatchRequest = Structure.new do
        # @return [String] The URI associated with an individual request within a batch. For
        # `FeaturedOfferExpectedPrice`, this is `/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice`.
        attribute(:uri, String)

        # @return [String]
        attribute(:method, String)

        # @return [Hash]
        attribute?(:body, Hash)

        # @return [HttpHeaders]
        attribute?(:headers, HttpHeaders)
      end
    end
  end
end
