# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # Tracking details of package
      PackageTrackingDetails = Structure.new do
        # The package identifier.
        attribute(:package_number, Integer, null: false, from: "packageNumber")

        # Known values: `AS_INSTRUCTED`, `CARPORT`, `CUSTOMER_PICKUP`, `DECK`, `DOOR_PERSON`, `FRONT_DESK`,
        # `FRONT_DOOR`, `GARAGE`, `GUARD`, `MAIL_ROOM`, `MAIL_SLOT`, `MAILBOX`, `MC_BOY`, `MC_GIRL`, `MC_MAN`,
        # `MC_WOMAN`, `NEIGHBOR`, `OFFICE`, `OUTBUILDING`, `PATIO`, `PORCH`, `REAR_DOOR`, `RECEPTIONIST`, `RECEIVER`,
        # `SECURE_LOCATION`, `SIDE_DOOR`.
        attribute?(:additional_location_info, String, from: "additionalLocationInfo")

        # The name of the carrier.
        attribute?(:carrier_code, String, from: "carrierCode")

        # The phone number of the carrier.
        attribute?(:carrier_phone_number, String, from: "carrierPhoneNumber")

        # The URL of the carrier's website.
        attribute?(:carrier_url, String, from: "carrierURL")

        # Known values: `IN_TRANSIT`, `DELIVERED`, `RETURNING`, `RETURNED`, `UNDELIVERABLE`, `DELAYED`,
        # `AVAILABLE_FOR_PICKUP`, `CUSTOMER_ACTION`, `UNKNOWN`, `OUT_FOR_DELIVERY`, `DELIVERY_ATTEMPTED`,
        # `PICKUP_SUCCESSFUL`, `PICKUP_CANCELLED`, `PICKUP_ATTEMPTED`, `PICKUP_SCHEDULED`, `RETURN_REQUEST_ACCEPTED`,
        # `REFUND_ISSUED`, `RETURN_RECEIVED_IN_FC`.
        attribute?(:current_status, String, from: "currentStatus")

        # Description corresponding to the `CurrentStatus` value.
        attribute?(:current_status_description, String, from: "currentStatusDescription")

        # Link on swiship.com that allows customers to track the package.
        attribute?(:customer_tracking_link, String, from: "customerTrackingLink")

        # The delivery window for the package. This is available after the package reaches its destination delivery
        # station.
        attribute?(:delivery_window, DateRange, from: "deliveryWindow")

        # The estimated arrival date.
        attribute?(:estimated_arrival_date, String, from: "estimatedArrivalDate")

        # The shipping date for the package.
        attribute?(:ship_date, String, from: "shipDate")

        # The destination city for the package.
        attribute?(:ship_to_address, TrackingAddress, from: "shipToAddress")

        # The name of the person who signed for the package.
        attribute?(:signed_for_by, String, from: "signedForBy")

        attribute?(:tracking_events, [TrackingEvent], from: "trackingEvents")

        # The tracking number for the package.
        attribute?(:tracking_number, String, from: "trackingNumber")
      end
    end
  end
end
