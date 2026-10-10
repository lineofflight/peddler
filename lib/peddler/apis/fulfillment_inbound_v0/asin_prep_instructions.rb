# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInboundV0
      # Item preparation instructions to help with item sourcing decisions.
      ASINPrepInstructions = Structure.new do
        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        attribute?(:barcode_instruction, String, from: "BarcodeInstruction")

        attribute?(:prep_guidance, String, from: "PrepGuidance")

        attribute?(:prep_instruction_list, Array, from: "PrepInstructionList")
      end
    end
  end
end
