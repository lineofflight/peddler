# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricingV0
      # A list of sales rank information for the item, by category.
      class SalesRankList < Array
        class << self
          def parse(array)
            new(array.map { |item| SalesRankType.parse(item) })
          end
        end
      end
    end
  end
end
