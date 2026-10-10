# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # A financial adjustment event for FBA liquidated inventory. A positive value indicates money owed to Amazon by
      # the buyer (for example, when the charge was incorrectly calculated as less than it should be). A negative value
      # indicates a full or partial refund owed to the buyer (for example, when the buyer receives damaged items or
      # fewer items than ordered).
      RemovalShipmentAdjustmentEvent = Structure.new do
        # The unique identifier for the adjustment event.
        attribute?(:adjustment_event_id, String, from: "AdjustmentEventId")

        # The merchant removal orderId.
        attribute?(:merchant_order_id, String, from: "MerchantOrderId")

        # The orderId for shipping inventory.
        attribute?(:order_id, String, from: "OrderId")

        # The date when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # A comma-delimited list of `RemovalShipmentItemAdjustment` details for FBA inventory.
        attribute?(:removal_shipment_item_adjustment_list, [RemovalShipmentItemAdjustment], from: "RemovalShipmentItemAdjustmentList")

        # The type of removal order.
        #
        # Possible values:
        #
        # * `WHOLESALE_LIQUIDATION`.
        attribute?(:transaction_type, String, from: "TransactionType")
      end
    end
  end
end
