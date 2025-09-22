# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/easy_ship_2022_03_23/item"
require "peddler/types/easy_ship_2022_03_23/time_slot"

module Peddler
  module Types
    module EasyShip20220323
      # Package details. Includes `packageItems`, `packageTimeSlot`, and `packageIdentifier`.
      PackageDetails = Structure.new do
        # @return [Array<Item>]
        attribute(:package_items, [Item], from: "packageItems")

        # @return [TimeSlot]
        attribute(:package_time_slot, TimeSlot, from: "packageTimeSlot")

        # @return [String]
        attribute(:package_identifier, String, from: "packageIdentifier")
      end
    end
  end
end
