# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_v0/http_request_headers"

module Peddler
  module Types
    module ProductPricingV0
      # Common properties of batch requests against individual APIs.
      BatchRequest = Structure.new do
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

        # @return [String]
        attribute(:method, String)

        # @return [HttpRequestHeaders]
        attribute?(:headers, HttpRequestHeaders)
      end
    end
  end
end
