# frozen_string_literal: true

require "peddler/money"

module Peddler
  module Types
    module ListingsItems20210801
      # The vendor procurement information for the listings item.
      ItemProcurement = Structure.new do
        # @return [Money] The price (numeric value) that you want Amazon to pay you for this product.
        attribute(:cost_price, Money, from: "costPrice")
      end
    end
  end
end
