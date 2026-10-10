# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInboundV0
      # Labeling requirements and item preparation instructions to help you prepare items for shipment to Amazon's
      # fulfillment network.
      SKUPrepInstructions = Structure.new do
        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        attribute?(:amazon_prep_fees_details_list, [AmazonPrepFeesDetails], from: "AmazonPrepFeesDetailsList")

        attribute?(:barcode_instruction, String, from: "BarcodeInstruction")

        attribute?(:prep_guidance, String, from: "PrepGuidance")

        attribute?(:prep_instruction_list, Array, from: "PrepInstructionList")

        # The seller SKU of the item.
        attribute?(:seller_sku, String, from: "SellerSKU")
      end
    end
  end
end
