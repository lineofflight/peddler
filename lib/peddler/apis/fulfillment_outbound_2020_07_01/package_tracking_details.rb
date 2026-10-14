# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # Tracking details of package
      PackageTrackingDetails = Structure.new do
        # @return [Integer] The package identifier.
        attribute(:package_number, Integer, null: false, from: "packageNumber")

        # @return [String] Known values: `AS_INSTRUCTED`, `CARPORT`, `CUSTOMER_PICKUP`, `DECK`, `DOOR_PERSON`,
        #   `FRONT_DESK`, `FRONT_DOOR`, `GARAGE`, `GUARD`, `MAIL_ROOM`, `MAIL_SLOT`, `MAILBOX`, `MC_BOY`, `MC_GIRL`,
        #   `MC_MAN`, `MC_WOMAN`, `NEIGHBOR`, `OFFICE`, `OUTBUILDING`, `PATIO`, `PORCH`, `REAR_DOOR`, `RECEPTIONIST`,
        #   `RECEIVER`, `SECURE_LOCATION`, `SIDE_DOOR`.
        attribute?(:additional_location_info, String, from: "additionalLocationInfo")

        # @return [String] The name of the carrier.
        attribute?(:carrier_code, String, from: "carrierCode")

        # @return [String] The phone number of the carrier.
        attribute?(:carrier_phone_number, String, from: "carrierPhoneNumber")

        # @return [String] The URL of the carrier's website.
        attribute?(:carrier_url, String, from: "carrierURL")

        # @return [String] Known values: `IN_TRANSIT`, `DELIVERED`, `RETURNING`, `RETURNED`, `UNDELIVERABLE`, `DELAYED`,
        #   `AVAILABLE_FOR_PICKUP`, `CUSTOMER_ACTION`, `UNKNOWN`, `OUT_FOR_DELIVERY`, `DELIVERY_ATTEMPTED`,
        #   `PICKUP_SUCCESSFUL`, `PICKUP_CANCELLED`, `PICKUP_ATTEMPTED`, `PICKUP_SCHEDULED`, `RETURN_REQUEST_ACCEPTED`,
        #   `REFUND_ISSUED`, `RETURN_RECEIVED_IN_FC`.
        attribute?(:current_status, String, from: "currentStatus")

        # @return [String] Description corresponding to the `CurrentStatus` value.
        attribute?(:current_status_description, String, from: "currentStatusDescription")

        # @return [String] Link on swiship.com that allows customers to track the package.
        attribute?(:customer_tracking_link, String, from: "customerTrackingLink")

        # @return [DateRange] The delivery window for the package. This is available after the package reaches its
        #   destination delivery station.
        attribute?(:delivery_window, DateRange, from: "deliveryWindow")

        # @return [String] The estimated arrival date.
        attribute?(:estimated_arrival_date, String, from: "estimatedArrivalDate")

        # @return [String] The shipping date for the package.
        attribute?(:ship_date, String, from: "shipDate")

        # @return [TrackingAddress] The destination city for the package.
        attribute?(:ship_to_address, TrackingAddress, from: "shipToAddress")

        # @return [String] The name of the person who signed for the package.
        attribute?(:signed_for_by, String, from: "signedForBy")

        # @return [Array<TrackingEvent>]
        attribute?(:tracking_events, [TrackingEvent], from: "trackingEvents")

        # @return [String] The tracking number for the package.
        attribute?(:tracking_number, String, from: "trackingNumber")
      end
    end
  end
end
