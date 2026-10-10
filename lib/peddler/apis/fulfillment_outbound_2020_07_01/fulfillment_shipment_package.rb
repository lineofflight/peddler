# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # Package information for a shipment in a fulfillment order.
      FulfillmentShipmentPackage = Structure.new do
        # Identifies the carrier who will deliver the shipment to the recipient.
        attribute(:carrier_code, String, null: false, from: "carrierCode")

        # Identifies a package in a shipment.
        attribute(:package_number, Integer, null: false, from: "packageNumber")

        # The Amazon fulfillment tracking number, if provided, can be used to obtain tracking and delivery information.
        attribute?(:amazon_fulfillment_tracking_number, String, from: "amazonFulfillmentTrackingNumber")

        # The delivery information of the package, this information is only available post package delivery to its
        # intended destination.
        attribute?(:delivery_information, DeliveryInformation, from: "deliveryInformation")

        # The estimated arrival date and time of the package, in ISO 8601 date time format.
        attribute?(:estimated_arrival_date, String, from: "estimatedArrivalDate")

        # The locker details, if provided can be used to access locker delivery box.
        attribute?(:locker_details, LockerDetails, from: "lockerDetails")

        # The tracking number, if provided, can be used to obtain tracking and delivery information.
        attribute?(:tracking_number, String, from: "trackingNumber")
      end
    end
  end
end
