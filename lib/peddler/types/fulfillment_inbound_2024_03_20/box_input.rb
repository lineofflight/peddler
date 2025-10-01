# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/dimensions"
require "peddler/types/fulfillment_inbound_2024_03_20/weight"
require "peddler/types/fulfillment_inbound_2024_03_20/item_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
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
        # `contentInformationSource` is `BARCODE_2D` or `MANUAL_PROCESS`.
        attribute?(:items, [ItemInput])
      end
    end
  end
end
