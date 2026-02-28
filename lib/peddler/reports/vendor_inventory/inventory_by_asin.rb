# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorInventory
      # Describes ASIN-aggregated inventory metrics for the vendor's account.
      InventoryByASIN = Structure.new do
        # @return [String] The Amazon Standard Identification Number.
        attribute(:asin, String, null: false)

        # @return [Date] The end date of the aggregated data.
        attribute(:end_date, Date, null: false, from: "endDate")

        # @return [Money] Cost of the inventory that Amazon received from the vendor, minus the cost of the inventory
        #   that was returned to the vendor. The cost returned to the vendor takes into account any products that were
        #   returned due to damaged merchandise. This number can be negative if more cost was returned than received.
        attribute(:net_received_inventory_cost, Money, null: false, from: "netReceivedInventoryCost")

        # @return [Integer] Units received from the vendor minus any units that were returned to the vendor. This number
        #   can be negative if more units were returned than received.
        attribute(:net_received_inventory_units, Integer, null: false, from: "netReceivedInventoryUnits")

        # @return [Integer] Number of units contained in Amazon’s confirmed purchase orders that are not yet received by
        #   Amazon. This number can be negative if the vendor has shipped more units than Amazon has requested.
        attribute(:open_purchase_order_units, Integer, null: false, from: "openPurchaseOrderUnits")

        # @return [Money] The cost of the inventory in Amazon fulfillment centers that is in sellable condition on the
        #   last day of the selected time window. Backorders count as negative cost, and can cause this value to be
        #   negative overall.
        attribute(:sellable_on_hand_inventory_cost, Money, null: false, from: "sellableOnHandInventoryCost")

        # @return [Integer] The number of units in Amazon fulfillment centers that is in sellable condition on the last
        #   day of the selected time window. Backorders count as negative units, and can cause this value to be negative
        #   overall.
        attribute(:sellable_on_hand_inventory_units, Integer, null: false, from: "sellableOnHandInventoryUnits")

        # @return [Date] The start date of the aggregated data.
        attribute(:start_date, Date, null: false, from: "startDate")

        # @return [Money] The cost of the inventory in Amazon fulfillment centers that is at least 90 days old, and is
        #   in a sellable condition on the last day of the selected time window. Backorders count as a negative cost,
        #   and can cause this value to be negative overall. Inventory age is computed based on when the inventory was
        #   received by Amazon.
        attribute?(:aged90_plus_days_sellable_inventory_cost, Money, from: "aged90PlusDaysSellableInventoryCost")

        # @return [Integer] The number of units in Amazon fulfillment centers that is at least 90 days old, and is in a
        #   sellable condition on the last day of the selected time window. Backorders count as negative units, and can
        #   cause this value to be negative overall. Inventory age is computed based on when the inventory was received
        #   by Amazon.
        attribute?(:aged90_plus_days_sellable_inventory_units, Integer, from: "aged90PlusDaysSellableInventoryUnits")

        # @return [Float] Average number of days between the submission of each purchase order unit and the time of
        #   receipt in Amazon's fulfillment centers.
        attribute?(:average_vendor_lead_time_days, Float, from: "averageVendorLeadTimeDays")

        # @return [Float] The number of units shipped (less customer returns), divided by the sum of the number of units
        #   held by Amazon at the beginning of this time window and the number of units received during this time
        #   window. This number could be negative if more units were returned than were shipped. This number can be
        #   greater than 1 if some inventory was sold while in transit between fulfillment centers.
        attribute?(:sell_through_rate, Float, from: "sellThroughRate")

        # @return [Integer] Number of units that have been ordered (or pre-ordered) but have not yet shipped.
        attribute?(:unfilled_customer_ordered_units, Integer, from: "unfilledCustomerOrderedUnits")

        # @return [Money] The cost of the excess inventory on the last day of the selected time window based on
        #   forecasted demand. Note that the forecasted demand may have already included some amount of excess inventory
        #   that makes economic sense to hold. This is the amount of inventory beyond the forecasted demand.
        attribute?(:unhealthy_inventory_cost, Money, from: "unhealthyInventoryCost")

        # @return [Integer] The number of excess inventory units on the last day of the selected time window based on
        #   forecasted demand. Note that the forecasted demand may have already included some amount of excess inventory
        #   that makes economic sense to hold. This is the amount of inventory beyond the forecasted demand.
        attribute?(:unhealthy_inventory_units, Integer, from: "unhealthyInventoryUnits")

        # @return [Money] The cost of the inventory in Amazon fulfillment centers that is in unsellable condition on the
        #   last day of the selected time window.
        attribute?(:unsellable_on_hand_inventory_cost, Money, from: "unsellableOnHandInventoryCost")

        # @return [Integer] The number of units in Amazon fulfillment centers that are in unsellable condition on the
        #   last day of the selected time window.
        attribute?(:unsellable_on_hand_inventory_units, Integer, from: "unsellableOnHandInventoryUnits")

        # @return [Float] The number of units that were confirmed by the vendor, divided by the number of units Amazon
        #   asked for. This rate will be 1 if all units that were requested during this time window were confirmed. This
        #   rate can be larger than 1 if the vendor has confirmed a greater quantity of units than Amazon requested.
        attribute?(:vendor_confirmation_rate, Float, from: "vendorConfirmationRate")
      end
    end
  end
end
