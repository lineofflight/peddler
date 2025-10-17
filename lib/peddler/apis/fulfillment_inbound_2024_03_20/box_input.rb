# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Input information for a given box.
      BoxInput = Structure.new do
        # @return [String]
        attribute(:content_information_source, String, from: "contentInformationSource")

        # @return [Dimensions]
        attribute(:dimensions, Dimensions)

        # @return [Integer] The number of containers where all other properties like weight or dimensions are identical.
        attribute(:quantity, Integer)

        # @return [Weight]
        attribute(:weight, Weight)

        # @return [Array<ItemInput>] The items and their quantity in the box. This must be empty if the box
        #   `contentInformationSource` is `BARCODE_2D` or `MANUAL_PROCESS`.
        attribute?(:items, [ItemInput])
      end
    end
  end
end
