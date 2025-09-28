# frozen_string_literal: true

require "peddler/types/product_pricing_v0/price"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
      # The payload for the `getPricing` and `getCompetitivePricing` operations.
      class PriceList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Price.parse(item) }) : new
          end
        end
      end
    end
  end
end
