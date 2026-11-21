# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains input information about a pallet to be used in the inbound plan.
      PalletInput = Structure.new do
        # The number of containers where all other properties like weight or dimensions are identical.
        attribute(:quantity, Integer, null: false)

        attribute?(:dimensions, Dimensions)

        # Known values: `STACKABLE`, `NON_STACKABLE`.
        attribute?(:stackability, String)

        attribute?(:weight, Weight)
      end
    end
  end
end
