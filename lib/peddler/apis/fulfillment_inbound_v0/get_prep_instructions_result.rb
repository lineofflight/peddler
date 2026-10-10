# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInboundV0
      # Result for the get prep instructions operation
      GetPrepInstructionsResult = Structure.new do
        attribute?(:asin_prep_instructions_list, [ASINPrepInstructions], from: "ASINPrepInstructionsList")

        attribute?(:invalid_asin_list, [InvalidASIN], from: "InvalidASINList")

        attribute?(:invalid_sku_list, [InvalidSKU], from: "InvalidSKUList")

        attribute?(:sku_prep_instructions_list, [SKUPrepInstructions], from: "SKUPrepInstructionsList")
      end
    end
  end
end
