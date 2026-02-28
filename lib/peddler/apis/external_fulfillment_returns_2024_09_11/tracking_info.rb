# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentReturns20240911
      # Information for tracking a return.
      TrackingInfo = Structure.new do
        # @return [String] The name of the third party courier service used to ship the return package.
        attribute(:carrier_name, String, null: false, from: "carrierName")

        # @return [String] The tracking ID of the return package.
        attribute(:tracking_id, String, null: false, from: "trackingId")
      end
    end
  end
end
