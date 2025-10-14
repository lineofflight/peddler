# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains input information about a pallet to be used in the inbound plan.
      PalletInput = Structure.new do
        # @return [Integer] The number of containers where all other properties like weight or dimensions are identical.
        attribute(:quantity, Integer)

        # @return [Dimensions]
        attribute?(:dimensions, Dimensions)

        # @return [String]
        attribute?(:stackability, String)

        # @return [Weight]
        attribute?(:weight, Weight)
      end
    end
  end
end
