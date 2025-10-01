# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_v0/asin_prep_instructions"
require "peddler/types/fulfillment_inbound_v0/invalid_asin"
require "peddler/types/fulfillment_inbound_v0/invalid_sku"
require "peddler/types/fulfillment_inbound_v0/sku_prep_instructions"

module Peddler
  module Types
    module FulfillmentInboundV0
      # Result for the get prep instructions operation
      GetPrepInstructionsResult = Structure.new do
        # @return [Array<ASINPrepInstructions>]
        attribute?(:asin_prep_instructions_list, [ASINPrepInstructions], from: "ASINPrepInstructionsList")

        # @return [Array<InvalidASIN>]
        attribute?(:invalid_asin_list, [InvalidASIN], from: "InvalidASINList")

        # @return [Array<InvalidSKU>]
        attribute?(:invalid_sku_list, [InvalidSKU], from: "InvalidSKUList")

        # @return [Array<SKUPrepInstructions>]
        attribute?(:sku_prep_instructions_list, [SKUPrepInstructions], from: "SKUPrepInstructionsList")
      end
    end
  end
end
