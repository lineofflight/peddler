# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_v0/amazon_prep_fees_details"

module Peddler
  module Types
    module FulfillmentInboundV0
      # Labeling requirements and item preparation instructions to help you prepare items for shipment to Amazon's
      # fulfillment network.
      SKUPrepInstructions = Structure.new do
        # @return [String] The seller SKU of the item.
        attribute?(:seller_sku, String, from: "SellerSKU")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        # @return [String]
        attribute?(:barcode_instruction, String, from: "BarcodeInstruction")

        # @return [String]
        attribute?(:prep_guidance, String, from: "PrepGuidance")

        # @return [Array<PrepInstruction>]
        attribute?(:prep_instruction_list, Array, from: "PrepInstructionList")

        # @return [Array<AmazonPrepFeesDetails>]
        attribute?(:amazon_prep_fees_details_list, [AmazonPrepFeesDetails], from: "AmazonPrepFeesDetailsList")
      end
    end
  end
end
