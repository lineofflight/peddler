# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/easy_ship_2022_03_23/dimensions"
require "peddler/types/easy_ship_2022_03_23/time_slot"
require "peddler/types/easy_ship_2022_03_23/weight"
require "peddler/types/easy_ship_2022_03_23/scheduled_package_id"
require "peddler/types/easy_ship_2022_03_23/invoice_data"
require "peddler/types/easy_ship_2022_03_23/item"
require "peddler/types/easy_ship_2022_03_23/tracking_details"

module Peddler
  module Types
    module EasyShip20220323
      # This object contains all the details of the scheduled Easy Ship package.
      Package = Structure.new do
        # @return [Dimensions]
        attribute(:package_dimensions, Dimensions, from: "packageDimensions")

        # @return [TimeSlot]
        attribute(:package_time_slot, TimeSlot, from: "packageTimeSlot")

        # @return [Weight]
        attribute(:package_weight, Weight, from: "packageWeight")

        # @return [ScheduledPackageId]
        attribute(:scheduled_package_id, ScheduledPackageId, from: "scheduledPackageId")

        # @return [InvoiceData]
        attribute?(:invoice, InvoiceData)

        # @return [String]
        attribute?(:package_identifier, String, from: "packageIdentifier")

        # @return [Array<Item>]
        attribute?(:package_items, [Item], from: "packageItems")

        # @return [String]
        attribute?(:package_status, String, from: "packageStatus")

        # @return [TrackingDetails]
        attribute?(:tracking_details, TrackingDetails, from: "trackingDetails")
      end
    end
  end
end
