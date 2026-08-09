# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Tracking20260130
      # The carrier information.
      CarrierTracking = Structure.new do
        # @return [String] The tracking number assigned by the carrier.
        attribute(:tracking_number, String, null: false, from: "trackingNumber")

        # @return [String] The carrier code associated with the carrier tracking number.
        attribute?(:carrier_code, String, from: "carrierCode")
      end
    end
  end
end
