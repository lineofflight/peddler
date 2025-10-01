# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Details about the estimated delivery window.
      ShipmentSchedule = Structure.new do
        # @return [String] The date and time at the end of the appointment window when the shipment is expected to be
        # delivered. Values are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format,
        # with UTC time zone or UTC offset. For example, 2020-07-16T23:00:00Z or 2020-07-16T23:00:00+01:00.
        attribute?(:appt_window_end_date_time, String, from: "apptWindowEndDateTime")

        # @return [String] The date and time at the start of the appointment window when the shipment is expected to be
        # delivered. Values are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format,
        # with UTC time zone or UTC offset. For example, 2020-07-16T23:00:00Z or 2020-07-16T23:00:00+01:00.
        attribute?(:appt_window_start_date_time, String, from: "apptWindowStartDateTime")

        # @return [String] Date on which the shipment is expected to reach the customer delivery location. Values are in
        # [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format, with UTC time zone or UTC
        # offset. For example, 2020-07-16T23:00:00Z or 2020-07-16T23:00:00+01:00.
        attribute?(:estimated_delivery_date_time, String, from: "estimatedDeliveryDateTime")
      end
    end
  end
end
