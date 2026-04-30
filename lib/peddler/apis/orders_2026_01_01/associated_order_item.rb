# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # An associated order item that a customer has purchased with the product. For example, a tire installation
      # service purchased with tires.
      AssociatedOrderItem = Structure.new do
        # @return [String] The type of association between the order items.
        #
        # **Possible values**:
        # - `VALUE_ADD_SERVICE` (The associated item is a service order)
        attribute?(:association_type, String, from: "associationType")

        # @return [String] The order identifier of the associated order item.
        attribute?(:order_id, String, from: "orderId")

        # @return [String] The order item identifier of the associated order item.
        attribute?(:order_item_id, String, from: "orderItemId")
      end
    end
  end
end
