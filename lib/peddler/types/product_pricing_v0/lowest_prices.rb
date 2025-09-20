# frozen_string_literal: true

require "peddler/types/product_pricing_v0/lowest_price_type"

module Peddler
  module Types
    module ProductPricingV0
      # A list of the lowest prices.
      class LowestPrices < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| LowestPriceType.parse(item) })
          end
        end
      end
    end
  end
end
