# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInboundV0
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
