# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/dimensions"
require "peddler/types/fulfillment_inbound_2024_03_20/item_input"
require "peddler/types/fulfillment_inbound_2024_03_20/weight"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Input information for updating a box
      BoxUpdateInput = Structure.new do
        # @return [String]
        attribute(:content_information_source, String, from: "contentInformationSource")

        # @return [Dimensions]
        attribute(:dimensions, Dimensions)

        # @return [Array<ItemInput>] The items and their quantity in the box. This must be empty if the box
        # `contentInformationSource` is `BARCODE_2D` or `MANUAL_PROCESS`.
        attribute?(:items, [ItemInput])

        # @return [String] Primary key to uniquely identify a Box Package. PackageId must be provided if the intent is
        # to update an existing box. Adding a new box will not require providing this value. Any existing PackageIds not
        # provided will be treated as to-be-removed
        attribute?(:package_id, String, from: "packageId")

        # @return [Integer] The number of containers where all other properties like weight or dimensions are identical.
        attribute(:quantity, Integer)

        # @return [Weight]
        attribute(:weight, Weight)
      end
    end
  end
end
