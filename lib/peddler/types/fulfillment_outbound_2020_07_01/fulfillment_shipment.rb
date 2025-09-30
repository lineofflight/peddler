# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_shipment_item"
require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_shipment_package"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Delivery and item information for a shipment in a fulfillment order.
      FulfillmentShipment = Structure.new do
        # @return [String] A shipment identifier assigned by Amazon.
        attribute(:amazon_shipment_id, String, from: "amazonShipmentId")

        # @return [String] An identifier for the fulfillment center from which the shipment is sent.
        attribute(:fulfillment_center_id, String, from: "fulfillmentCenterId")

        # @return [String] The current status of the shipment.
        attribute(:fulfillment_shipment_status, String, from: "fulfillmentShipmentStatus")

        # @return [String] The meaning of the `shippingDate` value depends on the current status of the shipment. If the
        # current value of FulfillmentShipmentStatus is:
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

        # @return [String] The estimated arrival date and time of the shipment, in ISO 8601 date time format. Note that
        # this value can change over time. If a shipment includes more than one package, `estimatedArrivalDate` applies
        # to all of the packages in the shipment. If the shipment is cancelled, `estimatedArrivalDate` is not returned.
        attribute?(:estimated_arrival_date, String, from: "estimatedArrivalDate")

        # @return [Array<String>] Provides additional insight into shipment timeline. Primarily used to communicate that
        # actual delivery dates aren't available.
        attribute?(:shipping_notes, [String], from: "shippingNotes")

        # @return [Array<FulfillmentShipmentItem>]
        attribute(:fulfillment_shipment_item, [FulfillmentShipmentItem], from: "fulfillmentShipmentItem")

        # @return [Array<FulfillmentShipmentPackage>]
        attribute?(:fulfillment_shipment_package, [FulfillmentShipmentPackage], from: "fulfillmentShipmentPackage")
      end
    end
  end
end
