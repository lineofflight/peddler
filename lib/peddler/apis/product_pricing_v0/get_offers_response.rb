# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # The response schema for the `getListingOffers` and `getItemOffers` operations.
      GetOffersResponse = Structure.new do
        # One or more unexpected errors occurred during the operation.
        attribute?(:errors, [Error])

        # The payload for the `getListingOffers` and `getItemOffers` operations.
        attribute?(:payload, GetOffersResult)
      end
    end
  end
end
