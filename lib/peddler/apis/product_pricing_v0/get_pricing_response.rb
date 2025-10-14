# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # The response schema for the `getPricing` and `getCompetitivePricing` operations.
      GetPricingResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the operation.
        attribute?(:errors, [Error])

        # @return [Array<Price>] The payload for the getPricing and getCompetitivePricing operations.
        attribute?(:payload, [Price])
      end
    end
  end
end
