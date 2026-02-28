# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The common properties for individual requests within a batch.
      BatchRequest = Structure.new do
        # @return [String]
        attribute(:method, String, null: false)

        # @return [String] The URI associated with an individual request within a batch. For
        #   `FeaturedOfferExpectedPrice`, this is `/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice`.
        attribute(:uri, String, null: false)

        # @return [Hash]
        attribute?(:body, Hash)

        # @return [Hash]
        attribute?(:headers, Hash)
      end
    end
  end
end
