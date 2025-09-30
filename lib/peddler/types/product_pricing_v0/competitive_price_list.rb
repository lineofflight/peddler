# frozen_string_literal: true

require "peddler/types/product_pricing_v0/competitive_price_type"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
      # A list of competitive pricing information.
      class CompetitivePriceList < Array
        class << self
          def parse(array)
            new(array.map { |item| CompetitivePriceType.parse(item) })
          end
        end
      end
    end
  end
end
