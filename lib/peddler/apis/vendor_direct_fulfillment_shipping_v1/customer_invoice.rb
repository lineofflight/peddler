# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # Represents a customer invoice associated with a purchase order.
      CustomerInvoice = Structure.new do
        # @return [String] The Base64encoded customer invoice.
        attribute(:content, String)

        # @return [String] The purchase order number for this order.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")
      end
    end
  end
end
