# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains information about a pallet that is used in the inbound plan. The pallet is a container that holds
      # multiple items or boxes.
      Pallet = Structure.new do
        # Primary key to uniquely identify a Package (Box or Pallet).
        attribute(:package_id, String, null: false, from: "packageId")

        attribute?(:dimensions, Dimensions)

        # The number of containers where all other properties like weight or dimensions are identical.
        attribute?(:quantity, Integer)

        # Known values: `STACKABLE`, `NON_STACKABLE`.
        attribute?(:stackability, String)

        attribute?(:weight, Weight)
      end
    end
  end
end
