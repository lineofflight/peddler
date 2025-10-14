# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricingV0
      # The payload for the `getPricing` and `getCompetitivePricing` operations.
      class PriceList < Array
        class << self
          def parse(array)
            new(array.map { |item| Price.parse(item) })
          end
        end
      end
    end
  end
end
