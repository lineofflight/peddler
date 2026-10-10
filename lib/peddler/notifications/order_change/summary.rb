# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module OrderChange
      # Information about order and order items that had the change.
      Summary = Structure.new do
        # The destination postal code. It will be null when there is no related information.
        attribute(:destination_postal_code, String, from: "DestinationPostalCode")

        # Fulfillment type of the affected order, MFN or AFN.
        attribute(:fulfillment_type, String, null: false, from: "FulfillmentType")

        # The Amazon marketplace identifier of the order.
        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # Information about order items included in this order. For OrderItemLevel notification, one payload include one
        # item, while for OrderLevel notification, one payload include all items.
        attribute(:order_items, [OrderItem], null: false, from: "OrderItems")

        # The current order status.
        attribute(:order_status, String, null: false, from: "OrderStatus")

        # The type of the order.
        attribute(:order_type, String, null: false, from: "OrderType")

        # The purchase date of the order, presented in ISO-8601 date/time format. It will be null when there is no
        # related information.
        attribute(:purchase_date, String, from: "PurchaseDate")

        # The end of the time period which you cancel notify for the order, presented in ISO-8601 date/time format.
        attribute?(:cancel_notify_date, String, from: "CancelNotifyDate")

        # The start of the time period within which you have committed to fulfill the order, presented in ISO-8601
        # date/time format. Returned only for seller-fulfilled orders.
        attribute?(:earliest_delivery_date, String, from: "EarliestDeliveryDate")

        # The start of the time period within which you have committed to ship the order, presented in ISO-8601
        # date/time format.
        attribute?(:earliest_ship_date, String, from: "EarliestShipDate")

        # The status of the Amazon Easy Ship order. This property is included only for Amazon Easy Ship orders.
        attribute?(:easy_ship_shipment_status, String, from: "EasyShipShipmentStatus")

        # The status of the electronic invoice.
        attribute?(:electronic_invoice_status, String, from: "ElectronicInvoiceStatus")

        # The end of the time period within which you have committed to fulfill the order, presented in ISO-8601
        # date/time format. Returned only for seller-fulfilled orders that do not have a PendingAvailability, Pending,
        # or Canceled status.
        attribute?(:latest_delivery_date, String, from: "LatestDeliveryDate")

        # The end of the time period within which you have committed to ship the order, presented in ISO-8601 date/time
        # format.
        attribute?(:latest_ship_date, String, from: "LatestShipDate")

        # The number of items shipped.
        attribute?(:number_of_items_shipped, Integer, from: "NumberOfItemsShipped")

        # The number of items unshipped.
        attribute?(:number_of_items_unshipped, Integer, from: "NumberOfItemsUnshipped")

        # The order programs, if any, in which this order participates.
        attribute?(:order_programs, [String], from: "OrderPrograms")

        # The shipping programs, if any, in which this order participates.
        attribute?(:shipping_programs, [String], from: "ShippingPrograms")
      end
    end
  end
end
