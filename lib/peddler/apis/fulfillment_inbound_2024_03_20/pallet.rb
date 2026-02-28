# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains information about a pallet that is used in the inbound plan. The pallet is a container that holds
      # multiple items or boxes.
      Pallet = Structure.new do
        # @return [String] Primary key to uniquely identify a Package (Box or Pallet).
        attribute(:package_id, String, null: false, from: "packageId")

        # @return [Dimensions]
        attribute?(:dimensions, Dimensions)

        # @return [Integer] The number of containers where all other properties like weight or dimensions are identical.
        attribute?(:quantity, Integer)

        # @return [String]
        attribute?(:stackability, String)

        # @return [Weight]
        attribute?(:weight, Weight)
      end
    end
  end
end
