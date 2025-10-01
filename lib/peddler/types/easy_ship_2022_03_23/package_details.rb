# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/easy_ship_2022_03_23/time_slot"
require "peddler/types/easy_ship_2022_03_23/item"

module Peddler
  module Types
    module EasyShip20220323
      # Package details. Includes `packageItems`, `packageTimeSlot`, and `packageIdentifier`.
      PackageDetails = Structure.new do
        # @return [TimeSlot]
        attribute(:package_time_slot, TimeSlot, from: "packageTimeSlot")

        # @return [String]
        attribute?(:package_identifier, String, from: "packageIdentifier")

        # @return [Array<Item>]
        attribute?(:package_items, [Item], from: "packageItems")
      end
    end
  end
end
