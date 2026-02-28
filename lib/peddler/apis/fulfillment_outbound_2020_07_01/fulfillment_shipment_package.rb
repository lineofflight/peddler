# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # Package information for a shipment in a fulfillment order.
      FulfillmentShipmentPackage = Structure.new do
        # @return [String] Identifies the carrier who will deliver the shipment to the recipient.
        attribute(:carrier_code, String, null: false, from: "carrierCode")

        # @return [Integer] Identifies a package in a shipment.
        attribute(:package_number, Integer, null: false, from: "packageNumber")

        # @return [String] The Amazon fulfillment tracking number, if provided, can be used to obtain tracking and
        #   delivery information.
        attribute?(:amazon_fulfillment_tracking_number, String, from: "amazonFulfillmentTrackingNumber")

        # @return [DeliveryInformation] The delivery information for the package. This information is available after
        #   the package is delivered.
        attribute?(:delivery_information, DeliveryInformation, from: "deliveryInformation")

        # @return [String] The estimated arrival date and time of the package. Must be in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute?(:estimated_arrival_date, String, from: "estimatedArrivalDate")

        # @return [LockerDetails] The locker details, if provided can be used to access locker delivery box.
        attribute?(:locker_details, LockerDetails, from: "lockerDetails")

        # @return [String] The tracking number, if provided, can be used to obtain tracking and delivery information.
        attribute?(:tracking_number, String, from: "trackingNumber")
      end
    end
  end
end
