# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Packing slip information.
      PackingSlip = Structure.new do
        # @return [String] Purchase order number of the shipment that corresponds to the packing slip.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] A Base64encoded string of the packing slip PDF.
        attribute(:content, String)

        # @return [String] The format of the file such as PDF, JPEG etc.
        attribute?(:content_type, String, from: "contentType")
      end
    end
  end
end
