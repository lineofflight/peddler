# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShipping20211228
      # Packing slip information.
      PackingSlip = Structure.new do
        # @return [String] A Base64 string of the packing slip PDF.
        attribute(:content, String)

        # @return [String] Purchase order number of the shipment that the packing slip is for.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] The format of the file such as PDF, JPEG etc.
        attribute?(:content_type, String, from: "contentType")
      end
    end
  end
end
