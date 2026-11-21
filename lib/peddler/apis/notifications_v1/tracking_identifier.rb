# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module NotificationsV1
      # Specifies the tracking identifier used to filter your subscription notifications. Provide exactly one identifier
      # field. Providing multiple identifier fields in a single request is not supported.
      TrackingIdentifier = Structure.new do
        # Air Cargo Shipment Identification Number.
        attribute?(:acsin, String)

        # Amazon Fulfillment Tracking Number.
        attribute?(:aftn, String)

        # Carrier-provided tracking identifier.
        attribute?(:carrier_tracking, Hash, from: "carrierTracking")

        # Container number provided by the Logistics Service Provider.
        attribute?(:container_number, String, from: "containerNumber")

        # House Bill of Lading number.
        attribute?(:house_bill_of_lading_number, String, from: "houseBillOfLadingNumber")

        # Amazon unique tracking identifier.
        attribute?(:id, String)

        # The PRO number assigned by the freight carrier
        attribute?(:pro_number, String, from: "proNumber")
      end
    end
  end
end
