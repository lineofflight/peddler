# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module OrdersV0
      # Product information on the number of items.
      ProductInfoDetail = Structure.new do
        # @return [String] The total number of items that are included in the ASIN.
        attribute(:number_of_items, String, from: "NumberOfItems")
      end
    end
  end
end
