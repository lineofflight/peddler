# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/dimensions"
require "peddler/types/fulfillment_inbound_2024_03_20/weight"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains information about a pallet that is used in the inbound plan. The pallet is a container that holds
      # multiple items or boxes.
      Pallet = Structure.new do
        # @return [Dimensions]
        attribute(:dimensions, Dimensions)

        # @return [String] Primary key to uniquely identify a Package (Box or Pallet).
        attribute(:package_id, String, from: "packageId")

        # @return [Integer] The number of containers where all other properties like weight or dimensions are identical.
        attribute(:quantity, Integer)

        # @return [String]
        attribute(:stackability, String)

        # @return [Weight]
        attribute(:weight, Weight)
      end
    end
  end
end
