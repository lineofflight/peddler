# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module EasyShip20220323
      # Package details. Includes `packageItems`, `packageTimeSlot`, and `packageIdentifier`.
      PackageDetails = Structure.new do
        attribute(:package_time_slot, TimeSlot, null: false, from: "packageTimeSlot")

        attribute?(:package_identifier, String, from: "packageIdentifier")

        attribute?(:package_items, [Item], from: "packageItems")
      end
    end
  end
end
