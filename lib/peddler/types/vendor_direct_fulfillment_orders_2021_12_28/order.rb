# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/order_details"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # Represents a purchase order.
      Order = Structure.new do
        # @return [String] The purchase order number for this order. Formatting Notes: alpha-numeric code.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [OrderDetails] Purchase order details.
        attribute?(:order_details, OrderDetails, from: "orderDetails")
      end
    end
  end
end
