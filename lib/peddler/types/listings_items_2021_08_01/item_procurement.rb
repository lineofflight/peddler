# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "structure"

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
