# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/easy_ship_2022_03_23/dimensions"
require "peddler/types/easy_ship_2022_03_23/weight"

module Peddler
  module Types
    module EasyShip20220323
      # The request schema for the `listHandoverSlots` operation.
      ListHandoverSlotsRequest = Structure.new do
        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String]
        attribute(:amazon_order_id, String, from: "amazonOrderId")

        # @return [Dimensions]
        attribute(:package_dimensions, Dimensions, from: "packageDimensions")

        # @return [Weight]
        attribute(:package_weight, Weight, from: "packageWeight")
      end
    end
  end
end
