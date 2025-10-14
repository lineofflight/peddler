# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Input information for updating a box
      BoxUpdateInput = Structure.new do
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

        # @return [String] Primary key to uniquely identify a Box Package. PackageId must be provided if the intent is
        # to update an existing box. Adding a new box will not require providing this value. Any existing PackageIds not
        # provided will be treated as to-be-removed
        attribute?(:package_id, String, from: "packageId")
      end
    end
  end
end
