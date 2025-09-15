# frozen_string_literal: true

require "peddler/types/product_pricing_v0/get_offers_result"
require "peddler/types/product_pricing_v0/error"

module Peddler
  module Types
    module ProductPricingV0
      # The response schema for the `getListingOffers` and `getItemOffers` operations.
      GetOffersResponse = Structure.new do
        # @return [GetOffersResult] The payload for the `getListingOffers` and `getItemOffers` operations.
        attribute(:payload, GetOffersResult)

        # @return [Array<Error>] One or more unexpected errors occurred during the operation.
        attribute(:errors, [Error])
      end
    end
  end
end
