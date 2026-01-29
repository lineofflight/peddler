# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # The money that the seller receives from the sale of the order.
      OrderProceeds = Structure.new do
        # @return [Money] The total amount that the seller receives from the sale of the order.
        attribute?(:grand_total, Money, from: "grandTotal")
      end
    end
  end
end
