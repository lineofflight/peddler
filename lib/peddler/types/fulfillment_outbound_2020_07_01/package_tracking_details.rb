# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/tracking_address"
require "peddler/types/fulfillment_outbound_2020_07_01/date_range"
require "peddler/types/fulfillment_outbound_2020_07_01/tracking_event"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Tracking details of package
      PackageTrackingDetails = Structure.new do
        # @return [Integer] The package identifier.
        attribute(:package_number, Integer, from: "packageNumber")

        # @return [String] The tracking number for the package.
        attribute(:tracking_number, String, from: "trackingNumber")

        # @return [String] Link on swiship.com that allows customers to track the package.
        attribute(:customer_tracking_link, String, from: "customerTrackingLink")

        # @return [String] The name of the carrier.
        attribute(:carrier_code, String, from: "carrierCode")

        # @return [String] The phone number of the carrier.
        attribute(:carrier_phone_number, String, from: "carrierPhoneNumber")

        # @return [String] The URL of the carrier's website.
        attribute(:carrier_url, String, from: "carrierURL")

        # @return [String] The shipping date for the package.
        attribute(:ship_date, String, from: "shipDate")

        # @return [String] The estimated arrival date.
        attribute(:estimated_arrival_date, String, from: "estimatedArrivalDate")

        # @return [TrackingAddress] The destination city for the package.
        attribute(:ship_to_address, TrackingAddress, from: "shipToAddress")

        # @return [String]
        attribute(:current_status, String, from: "currentStatus")

        # @return [String] Description corresponding to the `CurrentStatus` value.
        attribute(:current_status_description, String, from: "currentStatusDescription")

        # @return [DateRange] The delivery window for the package. This is available after the package reaches its
        # destination delivery station.
        attribute(:delivery_window, DateRange, from: "deliveryWindow")

        # @return [String] The name of the person who signed for the package.
        attribute(:signed_for_by, String, from: "signedForBy")

        # @return [String]
        attribute(:additional_location_info, String, from: "additionalLocationInfo")

        # @return [Array<TrackingEvent>]
        attribute(:tracking_events, [TrackingEvent], from: "trackingEvents")
      end
    end
  end
end
