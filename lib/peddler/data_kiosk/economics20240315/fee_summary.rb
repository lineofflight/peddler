# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The fees data summary for the seller's account aggregated by transaction event type: charge.
      FeeSummary = Structure.new do
        # Charge summary for a fee type.
        attribute?(:charge, Fee)

        # Charge summary for a fee type.
        attribute?(:charges, [Fee])

        # Fee type name, for example: "FBA fulfillment fees"
        attribute?(:fee_type_name, String, null: false, from: "feeTypeName")
      end
    end
  end
end
