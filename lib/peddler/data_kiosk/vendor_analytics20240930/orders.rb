# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Orders metric group. A null value for a given metric means that the metric is not available.
      Orders = Structure.new do
        # @return [Amount] The net Gross Merchandise Sales (GMS) for all orders on a given day.
        attribute?(:net_ordered_gms, Amount, from: "netOrderedGMS")

        # @return [Amount] The net shipped Gross Merchandise Sales (GMS) amount.
        attribute?(:net_shipment_gms, Amount, from: "netShipmentGMS")

        # @return [UnitsWithValue] The number of ordered units and the associated revenue in a given time period with
        #   adjustments made for prior sales, like returns/cancellations. This metric is also applicable for Kindle and
        #   Physical books. Ordered Revenue Amount (OPS) = Product Price * Ordered Units.
        attribute?(:ordered_units_with_revenue, UnitsWithValue, from: "orderedUnitsWithRevenue")

        # @return [String] Number of units ordered (or pre-ordered), but have not shipped.
        attribute?(:unfilled_ordered_units, String, from: "unfilledOrderedUnits")
      end
    end
  end
end
