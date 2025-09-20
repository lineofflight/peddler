# frozen_string_literal: true

require "peddler/types/product_pricing_v0/sales_rank_type"

module Peddler
  module Types
    module ProductPricingV0
      # A list of sales rank information for the item, by category.
      class SalesRankList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| SalesRankType.parse(item) })
          end
        end
      end
    end
  end
end
