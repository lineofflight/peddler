# frozen_string_literal: true

require "peddler/types/product_pricing_v0/buy_box_price_type"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
      # A list of the Buy Box prices.
      class BuyBoxPrices < Array
        class << self
          def parse(array)
            new(array.map { |item| BuyBoxPriceType.parse(item) })
          end
        end
      end
    end
  end
end
