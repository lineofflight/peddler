# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Input information for a given box.
      BoxInput = Structure.new do
        attribute(:content_information_source, String, null: false, from: "contentInformationSource")

        attribute(:dimensions, Dimensions, null: false)

        # The number of containers where all other properties like weight or dimensions are identical.
        attribute(:quantity, Integer, null: false)

        attribute(:weight, Weight, null: false)

        # The items and their quantity in the box. This must be empty if the box `contentInformationSource` is
        # `BARCODE_2D` or `MANUAL_PROCESS`.
        attribute?(:items, [ItemInput])
      end
    end
  end
end
