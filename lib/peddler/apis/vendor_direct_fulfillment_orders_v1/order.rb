# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentOrdersV1
      # Represents a purchase order.
      Order = Structure.new do
        # The purchase order number for this order. Formatting Notes: alpha-numeric code.
        attribute(:purchase_order_number, String, null: false, from: "purchaseOrderNumber")

        # Purchase order details.
        attribute?(:order_details, OrderDetails, from: "orderDetails")
      end
    end
  end
end
