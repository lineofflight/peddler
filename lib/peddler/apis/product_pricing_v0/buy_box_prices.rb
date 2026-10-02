# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
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
