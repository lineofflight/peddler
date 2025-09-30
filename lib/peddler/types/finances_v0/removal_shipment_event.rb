# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/removal_shipment_item"

module Peddler
  module Types
    module FinancesV0
      # A removal shipment event for a removal order.
      RemovalShipmentEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [String] The merchant removal orderId.
        attribute?(:merchant_order_id, String, from: "MerchantOrderId")

        # @return [String] The identifier for the removal shipment order.
        attribute?(:order_id, String, from: "OrderId")

        # @return [String] The type of removal order.
        #
        # Possible values:
        #
        # * WHOLESALE_LIQUIDATION
        attribute?(:transaction_type, String, from: "TransactionType")

        # @return [String] The name of the store where the event occurred.
        attribute?(:store_name, String, from: "StoreName")

        # @return [Array<RemovalShipmentItem>] A list of removal shipment items.
        attribute?(:removal_shipment_item_list, [RemovalShipmentItem], from: "RemovalShipmentItemList")
      end
    end
  end
end
