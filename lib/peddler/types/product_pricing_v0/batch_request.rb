# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # Common properties of batch requests against individual APIs.
      BatchRequest = Structure.new do
        # @return [String]
        attribute(:method, String)

        # @return [String] The resource path of the operation you are calling in batch without any query parameters.
        #
        # If you are calling `getItemOffersBatch`, supply the path of `getItemOffers`.
        #
        # **Example:** `/products/pricing/v0/items/B000P6Q7MY/offers`
        #
        # If you are calling `getListingOffersBatch`, supply the path of `getListingOffers`.
        #
        # **Example:** `/products/pricing/v0/listings/B000P6Q7MY/offers`
        attribute(:uri, String)

        # @return [Hash]
        attribute?(:headers, Hash)
      end
    end
  end
end
