# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class EasyShip20220323
      # The request schema for the `listHandoverSlots` operation.
      ListHandoverSlotsRequest = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, null: false, from: "amazonOrderId")

        # @return [String]
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Dimensions]
        attribute(:package_dimensions, Dimensions, null: false, from: "packageDimensions")

        # @return [Weight]
        attribute(:package_weight, Weight, null: false, from: "packageWeight")
      end
    end
  end
end
