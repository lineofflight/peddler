# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/removal_shipment_item_adjustment"

module Peddler
  module Types
    module FinancesV0
      # A financial adjustment event for FBA liquidated inventory. A positive value indicates money owed to Amazon by
      # the buyer (for example, when the charge was incorrectly calculated as less than it should be). A negative value
      # indicates a full or partial refund owed to the buyer (for example, when the buyer receives damaged items or
      # fewer items than ordered).
      RemovalShipmentAdjustmentEvent = Structure.new do
        # @return [String] The date when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [String] The unique identifier for the adjustment event.
        attribute?(:adjustment_event_id, String, from: "AdjustmentEventId")

        # @return [String] The merchant removal orderId.
        attribute?(:merchant_order_id, String, from: "MerchantOrderId")

        # @return [String] The orderId for shipping inventory.
        attribute?(:order_id, String, from: "OrderId")

        # @return [String] The type of removal order.
        #
        # Possible values:
        #
        # * WHOLESALE_LIQUIDATION.
        attribute?(:transaction_type, String, from: "TransactionType")

        # @return [Array<RemovalShipmentItemAdjustment>] A comma-delimited list of Removal shipmentItemAdjustment
        # details for FBA inventory.
        attribute?(:removal_shipment_item_adjustment_list, [RemovalShipmentItemAdjustment], from: "RemovalShipmentItemAdjustmentList")
      end
    end
  end
end
