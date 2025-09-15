# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Packing slip information.
      PackingSlip = Structure.new do
        # @return [String] Purchase order number of the shipment that the packing slip is for.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] A Base64 string of the packing slip PDF.
        attribute(:content, String)

        # @return [String] The format of the file such as PDF, JPEG etc.
        attribute(:content_type, String, from: "contentType")
      end
    end
  end
end
