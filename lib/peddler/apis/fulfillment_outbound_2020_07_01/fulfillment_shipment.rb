# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # Delivery and item information for a shipment in a fulfillment order.
      FulfillmentShipment = Structure.new do
        # A shipment identifier assigned by Amazon.
        attribute(:amazon_shipment_id, String, null: false, from: "amazonShipmentId")

        # An identifier for the fulfillment center from which the shipment is sent.
        attribute(:fulfillment_center_id, String, null: false, from: "fulfillmentCenterId")

        attribute(:fulfillment_shipment_item, [FulfillmentShipmentItem], null: false, from: "fulfillmentShipmentItem")

        # The current status of the shipment.
        attribute(:fulfillment_shipment_status, String, null: false, from: "fulfillmentShipmentStatus")

        # The estimated arrival date and time of the shipment, in ISO 8601 date time format. Note that this value can
        # change over time. If a shipment includes more than one package, `estimatedArrivalDate` applies to all of the
        # packages in the shipment. If the shipment is cancelled, `estimatedArrivalDate` is not returned.
        attribute?(:estimated_arrival_date, String, from: "estimatedArrivalDate")

        attribute?(:fulfillment_shipment_package, [FulfillmentShipmentPackage], from: "fulfillmentShipmentPackage")

        # The meaning of the `shippingDate` value depends on the current status of the shipment. If the current value of
        # FulfillmentShipmentStatus is:
        #
        # * Pending - shippingDate represents the estimated time that the shipment will leave the Amazon fulfillment
        # center.
        #
        # * Shipped - shippingDate represents the date that the shipment left the Amazon fulfillment center.
        #
        # If a shipment includes more than one package, `shippingDate` applies to all of the packages in the shipment.
        # If the value of `FulfillmentShipmentStatus` is `CancelledByFulfiller` or `CancelledBySeller`, `shippingDate`
        # is not returned. The value must be in ISO 8601 date time format.
        attribute?(:shipping_date, String, from: "shippingDate")

        # Provides additional insight into shipment timeline. Primarily used to communicate that actual delivery dates
        # aren't available.
        attribute?(:shipping_notes, [String], from: "shippingNotes")
      end
    end
  end
end
