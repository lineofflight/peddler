# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for tracking services provided by Amazon.
    #
    # The Tracking Selling Partner API allows users to track shipments to and from Amazon-owned storage warehouses,
    # fulfillment centers, and external warehouses.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/tracking-api-model/tracking_2026-01-30.json
    class Tracking20260130 < API
      # Returns tracking information for a shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param id [String] The unique tracking request identifier.
      # @param acsin [String] The Air Cargo Shipment Identification Number.
      # @param aftn [String] The Amazon Fulfillment Tracking Number.
      # @param container_number [String] The container number provided by the Logistics Service Provider.
      # @param house_bill_of_lading_number [String] The House Bill of Lading (HBL) number.
      # @param carrier_tracking_tracking_number [String] The tracking number assigned by the carrier.
      # @param carrier_tracking_carrier_code [String] The carrier code associated with the carrier tracking number.
      # @param accept_language [String] The preferred natural language and locale of the client, in POSIX locale format.
      #   Currently supports `en-US` only.
      # @return [Peddler::Response] The API response
      def get_shipment_tracking(id: nil, acsin: nil, aftn: nil, container_number: nil, house_bill_of_lading_number: nil,
        carrier_tracking_tracking_number: nil, carrier_tracking_carrier_code: nil, accept_language: nil)
        path = "/tracking/2026-01-30/shipments/track"
        params = {
          "id" => id,
          "acsin" => acsin,
          "aftn" => aftn,
          "containerNumber" => container_number,
          "houseBillOfLadingNumber" => house_bill_of_lading_number,
          "carrierTracking.trackingNumber" => carrier_tracking_tracking_number,
          "carrierTracking.carrierCode" => carrier_tracking_carrier_code,
        }.compact
        parser = -> { GetShipmentTrackingResponse }
        get(path, params:, parser:)
      end
    end
  end
end
