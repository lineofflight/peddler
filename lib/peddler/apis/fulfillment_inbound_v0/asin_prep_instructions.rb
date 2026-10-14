# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInboundV0
      # Item preparation instructions to help with item sourcing decisions.
      ASINPrepInstructions = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        # @return [String] Known values: `RequiresFNSKULabel`, `CanUseOriginalBarcode`, `MustProvideSellerSKU`.
        attribute?(:barcode_instruction, String, from: "BarcodeInstruction")

        # @return [String] Known values: `ConsultHelpDocuments`, `NoAdditionalPrepRequired`, `SeePrepInstructionsList`.
        attribute?(:prep_guidance, String, from: "PrepGuidance")

        # @return [Array<PrepInstruction>] Known values: `Polybagging`, `BubbleWrapping`, `Taping`,
        #   `BlackShrinkWrapping`, `Labeling`, `HangGarment`, `SetCreation`, `Boxing`, `RemoveFromHanger`, `Debundle`,
        #   `SuffocationStickering`, `CapSealing`, `SetStickering`, `BlankStickering`, `ShipsInProductPackaging`,
        #   `NoPrep`.
        attribute?(:prep_instruction_list, Array, from: "PrepInstructionList")
      end
    end
  end
end
