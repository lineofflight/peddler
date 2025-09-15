# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Represents a customer invoice associated with a purchase order.
      CustomerInvoice = Structure.new do
        # @return [String] The purchase order number for this order.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] The Base64encoded customer invoice.
        attribute(:content, String)
      end
    end
  end
end
