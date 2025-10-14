# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorRealTimeInventory
      # Contains details about ASIN and inventory count combinations for the specified time range.
      ReportData = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN).
        attribute(:asin, String)

        # @return [Time] The end of a date-time range in UTC representing the end of the hour for this object.
        attribute(:end_time, Time, from: "endTime")

        # @return [Integer] The number of units available to be sold on the website, based on units in Amazon
        # fulfillment centers that are in sellable condition less units in customer shopping carts or otherwise bound
        # for other orders (e.g. known subscribe-and-save orders).
        attribute(:highly_available_inventory, Integer, from: "highlyAvailableInventory")

        # @return [Time] The start of a date-time range in UTC representing the beginning of the hour for this object.
        attribute(:start_time, Time, from: "startTime")
      end
    end
  end
end
