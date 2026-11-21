# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # An item that is associated with an order item. For example, a tire installation service that is purchased with
      # tires.
      AssociatedItem = Structure.new do
        # Known values: `VALUE_ADD_SERVICE`.
        attribute?(:association_type, String, from: "AssociationType")

        # The order item's order identifier, in 3-7-7 format.
        attribute?(:order_id, String, from: "OrderId")

        # An Amazon-defined item identifier for the associated item.
        attribute?(:order_item_id, String, from: "OrderItemId")
      end
    end
  end
end
