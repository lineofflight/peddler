# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentInboundV0
      # Item preparation instructions to help with item sourcing decisions.
      ASINPrepInstructions = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        # @return [String]
        attribute?(:barcode_instruction, String, from: "BarcodeInstruction")

        # @return [String]
        attribute?(:prep_guidance, String, from: "PrepGuidance")

        # @return [Array<PrepInstruction>]
        attribute?(:prep_instruction_list, Array, from: "PrepInstructionList")
      end
    end
  end
end
