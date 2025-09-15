# frozen_string_literal: true

require "peddler/types/product_pricing_v0/price"
require "peddler/types/product_pricing_v0/error"

module Peddler
  module Types
    module ProductPricingV0
      # The response schema for the `getPricing` and `getCompetitivePricing` operations.
      GetPricingResponse = Structure.new do
        # @return [Array<Price>] The payload for the getPricing and getCompetitivePricing operations.
        attribute(:payload, [Price])

        # @return [Array<Error>] One or more unexpected errors occurred during the operation.
        attribute(:errors, [Error])
      end
    end
  end
end
