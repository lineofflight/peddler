# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module OrderStatusChange
      # Nested notification data
      OrderStatusChangeNotification = Structure.new do
        # @return [String] An Amazon-defined order identifier in 3-7-7 format.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] Fulfillment channel of the affected order, MFN or AFN.
        attribute(:fulfillment_channel, String, from: "FulfillmentChannel")

        # @return [String] Amazon marketplace identifier of the affected order.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] The Amazon-defined order item identifier.
        attribute(:order_item_id, String, from: "OrderItemId")

        # @return [String] The current order status. The possible values include UpComing, Pending, Unshipped,
        #   PartiallyShipped, PendingAvailability, Canceled, InvoiceUnconfirmed, Shipped, and Unfulfillable.
        attribute(:order_status, String, from: "OrderStatus")

        # @return [Integer] The number of items in the order.
        attribute(:quantity, Integer, from: "Quantity")

        # @return [String] The selling partner identifier.
        attribute(:seller_id, String, from: "SellerId")

        # @return [String] The seller-specific SKU identifier for an item.
        attribute(:seller_sku, String, from: "SellerSKU")

        # @return [String] The destination postal code.
        attribute?(:destination_postal_code, String, from: "DestinationPostalCode")

        # @return [String] The purchase date of the order in Epoch time.
        attribute?(:purchase_date, String, from: "PurchaseDate")

        # @return [String] The unique identifier of the supply source.
        attribute?(:supply_source_id, String, from: "SupplySourceId")
      end
    end
  end
end
