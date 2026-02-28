# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The tracking details of the package if it is shipped by a third party courier. This attribute should only be
      # provided when the value of `shipBy` is `THIRD_PARTY_CARRIER`.
      CourierSupportedAttributes = Structure.new do
        # @return [String] The name of the courier service used to ship the package
        attribute(:carrier_name, String, null: false, from: "carrierName")

        # @return [String] The tracking number of the package.
        attribute(:tracking_id, String, null: false, from: "trackingId")
      end
    end
  end
end
