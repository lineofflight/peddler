# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # The response schema for the `getPricing` and `getCompetitivePricing` operations.
      GetPricingResponse = Structure.new do
        # One or more unexpected errors occurred during the operation.
        attribute?(:errors, [Error])

        # The payload for the getPricing and getCompetitivePricing operations.
        attribute?(:payload, [Price])
      end
    end
  end
end
