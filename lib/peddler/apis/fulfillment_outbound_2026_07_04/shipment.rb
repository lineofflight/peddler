# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Delivery and item information for a shipment in a fulfillment order.
      Shipment = Structure.new do
        attribute(:amazon_facility, AmazonFacility, null: false, from: "amazonFacility")

        # A shipment identifier assigned by Amazon.
        attribute(:amazon_shipment_id, String, null: false, from: "amazonShipmentId")

        # An array of fulfillment shipment item information.
        attribute(:items, [ShipmentItem], null: false)

        attribute(:status, String, null: false)

        # The estimated delivery date and time of the shipment, in ISO 8601 date time format. Note that this value can
        # change over time. If a shipment includes more than one package, `deliveryTime` applies to all of the packages
        # in the shipment. If the shipment has been cancelled, `deliveryTime` is not returned.
        attribute?(:delivery_time, String, from: "deliveryTime")

        # An array of fulfillment shipment package information.
        attribute?(:packages, [Package])

        # The actualized service level for this shipment.
        attribute?(:service_level, ShipmentServiceLevel, from: "serviceLevel")

        # The meaning of `shipTime` depends on the current status of the shipment:
        #
        # * Processing - `shipTime` is the estimated time that the shipment will leave the Amazon fulfillment center.
        # * Shipped - `shipTime` is the date that the shipment left the Amazon fulfillment center.
        #
        # If a shipment includes more than one package, `shipTime` applies to all of the packages in the shipment. If
        # the shipment status is `CANCELLED`, `shipTime` is not returned. The value must be in ISO 8601 date time
        # format.
        attribute?(:ship_time, String, from: "shipTime")

        # Provides additional insight into shipment timeline. Primarily used to communicate that actual delivery dates
        # aren't available.
        attribute?(:shipping_notes, [String], from: "shippingNotes")
      end
    end
  end
end
