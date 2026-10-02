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
    module Tracking20260130
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "tracking_2026_01_30.get_shipment_tracking" => -> { GetShipmentTrackingResponse },
      }.freeze
    end
  end
end
