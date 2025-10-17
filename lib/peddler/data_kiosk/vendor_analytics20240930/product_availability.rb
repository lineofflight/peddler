# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Product availability metric group. A null value for a given metric means that the metric is not available.
      ProductAvailability = Structure.new do
        # @return [UnitsWithValue] The number of units and their cost that is at least 90 days old and in sellable
        #   condition on the last day of the selected time frame.
        attribute?(:aged90_days_sellable_inventory, UnitsWithValue, from: "aged90DaysSellableInventory")

        # @return [Float] Calculated as the number of units shipped in comparison to the number of units at Amazon at
        #   the start of the period, plus any units received during the same time period. Sell Through Rate = (Shipped
        #   Units - Customer Returns) / (Sellable On Hand Units + Net Received Units).
        attribute?(:sell_through_rate, Float, from: "sellThroughRate")

        # @return [String] The number of sellable units in transit inventory at the end of a specified time period.
        attribute?(:sellable_in_transit_inventory, String, from: "sellableInTransitInventory")

        # @return [UnitsWithValue] The number of units and their cost in Amazon FCs that is in sellable condition on the
        #   last day of the selected time frame.
        attribute?(:sellable_on_hand_inventory, UnitsWithValue, from: "sellableOnHandInventory")

        # @return [Float] The sourceable replenishment out of stock percentage, which is the percentage of retail that
        #   is available for all ASINs with a sourceable retail vendor.
        attribute?(:sourceable_roos, Float, from: "sourceableROOS")

        # @return [Float] Ultra Fast Track (UFT), is an hourly measure of the percentage of time an ASIN is available to
        #   be shipped to the customer from an FC via Prime shipping, versus the selection Amazon intended to carry.
        #   This metric takes into account a Customer Importance Factor (CIF), which weighs the ASIN’s importance to
        #   shoppers against Amazon’s cost of having that item in stock.
        attribute?(:ultra_fast_track, Float, from: "ultraFastTrack")

        # @return [UnitsWithValue] Excess number of units and their cost on the last day of the selected time frame
        #   based on forecasted demand. (Note:Not Available for Daily/Custom Time selections)
        attribute?(:unhealthy_inventory, UnitsWithValue, from: "unhealthyInventory")

        # @return [String] The number of unsellable units in transit inventory at the end of a specified time period.
        attribute?(:unsellable_in_transit_inventory, String, from: "unsellableInTransitInventory")

        # @return [UnitsWithValue] The number of units and their cost in Amazon FCs that is in unsellable condition on
        #   the last day of the selected time frame.
        attribute?(:unsellable_on_hand_inventory, UnitsWithValue, from: "unsellableOnHandInventory")
      end
    end
  end
end
