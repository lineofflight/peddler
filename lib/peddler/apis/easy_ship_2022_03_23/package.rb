# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module EasyShip20220323
      # This object contains all the details of the scheduled Easy Ship package.
      Package = Structure.new do
        attribute(:package_dimensions, Dimensions, null: false, from: "packageDimensions")

        attribute(:package_time_slot, TimeSlot, null: false, from: "packageTimeSlot")

        attribute(:package_weight, Weight, null: false, from: "packageWeight")

        attribute(:scheduled_package_id, ScheduledPackageId, null: false, from: "scheduledPackageId")

        attribute?(:invoice, InvoiceData)

        attribute?(:package_identifier, String, from: "packageIdentifier")

        attribute?(:package_items, [Item], from: "packageItems")

        attribute?(:package_status, String, from: "packageStatus")

        attribute?(:tracking_details, TrackingDetails, from: "trackingDetails")
      end
    end
  end
end
