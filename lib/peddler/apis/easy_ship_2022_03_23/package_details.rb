# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class EasyShip20220323
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
