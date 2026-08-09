# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # Specifies the tracking identifier used to filter your subscription notifications. Provide exactly one identifier
      # field. Providing multiple identifier fields in a single request is not supported.
      TrackingIdentifier = Structure.new do
        # @return [String] Air Cargo Shipment Identification Number.
        attribute?(:acsin, String)

        # @return [String] Amazon Fulfillment Tracking Number.
        attribute?(:aftn, String)

        # @return [Hash] Carrier-provided tracking identifier.
        attribute?(:carrier_tracking, Hash, from: "carrierTracking")

        # @return [String] Container number provided by the Logistics Service Provider.
        attribute?(:container_number, String, from: "containerNumber")

        # @return [String] House Bill of Lading number.
        attribute?(:house_bill_of_lading_number, String, from: "houseBillOfLadingNumber")

        # @return [String] Amazon unique tracking identifier.
        attribute?(:id, String)
      end
    end
  end
end
