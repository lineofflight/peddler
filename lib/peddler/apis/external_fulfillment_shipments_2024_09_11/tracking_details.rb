# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The carrier and tracking details of a package.
      TrackingDetails = Structure.new do
        # @return [String] The carrier responsible for transporting this package to the customer.
        attribute(:carrier, String, null: false)

        # @return [String] The specific shipping method or service used for delivering this package.
        attribute?(:shipping_service, String, from: "shippingService")

        # @return [String] The carrier-provided tracking number that customers can use to monitor the package's delivery
        #   progress.
        attribute?(:tracking_id, String, from: "trackingId")
      end
    end
  end
end
