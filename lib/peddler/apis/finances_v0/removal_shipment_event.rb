# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # A removal shipment event for a removal order.
      RemovalShipmentEvent = Structure.new do
        # @return [String] The merchant removal `orderId`.
        attribute?(:merchant_order_id, String, from: "MerchantOrderId")

        # @return [String] The identifier for the removal shipment order.
        attribute?(:order_id, String, from: "OrderId")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [Array<RemovalShipmentItem>] A list of removal shipment items.
        attribute?(:removal_shipment_item_list, [RemovalShipmentItem], from: "RemovalShipmentItemList")

        # @return [String] The name of the store where the event occurred.
        attribute?(:store_name, String, from: "StoreName")

        # @return [String] The type of removal order.
        #
        # Possible values:
        #
        # * `WHOLESALE_LIQUIDATION`
        attribute?(:transaction_type, String, from: "TransactionType")
      end
    end
  end
end
