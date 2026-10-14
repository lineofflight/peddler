# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInboundV0
      # Preparation instructions and who is responsible for the preparation.
      PrepDetails = Structure.new do
        # @return [String] Known values: `Polybagging`, `BubbleWrapping`, `Taping`, `BlackShrinkWrapping`, `Labeling`,
        #   `HangGarment`, `SetCreation`, `Boxing`, `RemoveFromHanger`, `Debundle`, `SuffocationStickering`,
        #   `CapSealing`, `SetStickering`, `BlankStickering`, `ShipsInProductPackaging`, `NoPrep`.
        attribute(:prep_instruction, String, null: false, from: "PrepInstruction")

        # @return [String] Known values: `AMAZON`, `SELLER`.
        attribute(:prep_owner, String, null: false, from: "PrepOwner")
      end
    end
  end
end
