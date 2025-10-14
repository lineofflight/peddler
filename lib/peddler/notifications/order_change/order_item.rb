# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module OrderChange
      # Information about every order item.
      OrderItem = Structure.new do
        # @return [String] The Amazon-defined order item identifier.
        attribute(:order_item_id, String, from: "OrderItemId")

        # @return [Integer] The number of items in the order.
        attribute(:quantity, Integer, from: "Quantity")

        # @return [String] The seller-specific SKU for an item.
        attribute(:seller_sku, String, from: "SellerSKU")

        # @return [String] The unique identifier of the supply source. Will be null when there is no related
        # information.
        attribute(:supply_source_id, String, from: "SupplySourceId")

        # @return [:boolean] True when the buyer has requested cancelation.
        attribute?(:buyer_requested_cancel, :boolean, from: "IsBuyerRequestedCancel")

        # @return [String] The start of the time period during which you have committed to fulfill the order.
        attribute?(:item_earliest_delivery_date, String, from: "ItemEarliestDeliveryDate")

        # @return [String] The end of the time period during which you have committed to fulfill the order.
        attribute?(:item_latest_delivery_date, String, from: "ItemLatestDeliveryDate")

        # @return [String] The current status of the order item. This field Will have a non-null value when items'
        # statuses are different.
        attribute?(:order_item_status, String, from: "OrderItemStatus")

        # @return [Integer] The number of items shipped.
        attribute?(:quantity_shipped, Integer, from: "QuantityShipped")
      end
    end
  end
end
