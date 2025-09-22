# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Represents a customer invoice associated with a purchase order.
      CustomerInvoice = Structure.new do
        # @return [String] The purchase order number for this order.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] The Base64 customer invoice.
        attribute(:content, String)
      end
    end
  end
end
