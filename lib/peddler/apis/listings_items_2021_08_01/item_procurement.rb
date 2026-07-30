# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The listings item's vendor procurement information.
      ItemProcurement = Structure.new do
        # @return [Money] The price (numeric value) that you want Amazon to pay you for this product.
        attribute(:cost_price, Money, null: false, from: "costPrice")
      end
    end
  end
end
