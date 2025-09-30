# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_v0/sku_prep_instructions"
require "peddler/types/fulfillment_inbound_v0/invalid_sku"
require "peddler/types/fulfillment_inbound_v0/asin_prep_instructions"
require "peddler/types/fulfillment_inbound_v0/invalid_asin"

module Peddler
  module Types
    module FulfillmentInboundV0
      # Result for the get prep instructions operation
      GetPrepInstructionsResult = Structure.new do
        # @return [Array<SKUPrepInstructions>]
        attribute?(:sku_prep_instructions_list, [SKUPrepInstructions], from: "SKUPrepInstructionsList")

        # @return [Array<InvalidSKU>]
        attribute?(:invalid_sku_list, [InvalidSKU], from: "InvalidSKUList")

        # @return [Array<ASINPrepInstructions>]
        attribute?(:asin_prep_instructions_list, [ASINPrepInstructions], from: "ASINPrepInstructionsList")

        # @return [Array<InvalidASIN>]
        attribute?(:invalid_asin_list, [InvalidASIN], from: "InvalidASINList")
      end
    end
  end
end
