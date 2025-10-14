# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorOrdersV1
      # Represents an order placed by Amazon, including the purchase order number, current state, and order details.
      Order = Structure.new do
        # @return [String] The purchase order number for this order. Formatting Notes: 8-character alpha-numeric code.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] This field will contain the current state of the purchase order.
        attribute(:purchase_order_state, String, from: "purchaseOrderState")

        # @return [OrderDetails] Details of an order.
        attribute?(:order_details, OrderDetails, from: "orderDetails")
      end
    end
  end
end
