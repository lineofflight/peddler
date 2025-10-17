# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module OrderChange
      # Information about the order and order items that had the change.
      Summary = Structure.new do
        # @return [String] The destination postal code. It will be null when there is no related information.
        attribute(:destination_postal_code, String, from: "DestinationPostalCode")

        # @return [String] Fulfillment type of the affected order, MFN or AFN.
        attribute(:fulfillment_type, String, from: "FulfillmentType")

        # @return [String] The Amazon marketplace identifier of the order.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [Array<OrderItem>] Information about order items included in this order. For OrderItemLevel
        #   notifications, one payload includes one item, while for OrderLevel notifications, one payload includes all
        #   items.
        attribute(:order_items, [OrderItem], from: "OrderItems")

        # @return [String] The current order status.
        attribute(:order_status, String, from: "OrderStatus")

        # @return [String] The type of the order.
        attribute(:order_type, String, from: "OrderType")

        # @return [String] The purchase date of the order, in ISO-8601 date/time format. It will be null when there is
        #   no related information.
        attribute(:purchase_date, String, from: "PurchaseDate")

        # @return [String] The end of the time period during which you must notify the seller of possible cancellation,
        #   in ISO-8601 date/time format.
        attribute?(:cancel_notify_date, String, from: "CancelNotifyDate")

        # @return [String] The start of the time period during which you committed to fulfill the order, in ISO-8601
        #   date/time format. Returned only for seller-fulfilled orders.
        attribute?(:earliest_delivery_date, String, from: "EarliestDeliveryDate")

        # @return [String] The start of the time period during which you committed to ship the order, in ISO-8601
        #   date/time format.
        attribute?(:earliest_ship_date, String, from: "EarliestShipDate")

        # @return [String] The status of the Amazon Easy Ship order. This property is included only for Amazon Easy Ship
        #   orders.
        attribute?(:easy_ship_shipment_status, String, from: "EasyShipShipmentStatus")

        # @return [String] The status of the electronic invoice.
        attribute?(:electronic_invoice_status, String, from: "ElectronicInvoiceStatus")

        # @return [String] The end of the time period during which you committed to fulfill the order, in ISO-8601
        #   date/time format. Returned only for seller-fulfilled orders that do not have a PendingAvailability, Pending,
        #   or Canceled status.
        attribute?(:latest_delivery_date, String, from: "LatestDeliveryDate")

        # @return [String] The end of the time period during which you committed to ship the order, in ISO-8601
        #   date/time format.
        attribute?(:latest_ship_date, String, from: "LatestShipDate")

        # @return [Integer] The number of items shipped.
        attribute?(:number_of_items_shipped, Integer, from: "NumberOfItemsShipped")

        # @return [Integer] The number of items unshipped.
        attribute?(:number_of_items_unshipped, Integer, from: "NumberOfItemsUnshipped")

        # @return [Array<String>] The order programs in which this order participates.
        attribute?(:order_programs, [String], from: "OrderPrograms")

        # @return [Array<String>] The shipping programs in which this order participates.
        attribute?(:shipping_programs, [String], from: "ShippingPrograms")
      end
    end
  end
end
