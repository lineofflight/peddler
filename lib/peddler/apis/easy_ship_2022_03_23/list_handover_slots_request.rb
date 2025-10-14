# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class EasyShip20220323
      # The request schema for the `listHandoverSlots` operation.
      ListHandoverSlotsRequest = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, from: "amazonOrderId")

        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Dimensions]
        attribute(:package_dimensions, Dimensions, from: "packageDimensions")

        # @return [Weight]
        attribute(:package_weight, Weight, from: "packageWeight")
      end
    end
  end
end
