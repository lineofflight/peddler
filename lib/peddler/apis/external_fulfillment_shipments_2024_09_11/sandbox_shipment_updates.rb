# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The update details for the sandbox shipment. For `SHIPMENT_STATUS_CHANGE`, provide either `status` or
      # `subStatus` (mutually exclusive). For `TRANSPORT_CAPACITY_CHANGE`, provide `timestamp` as the Expected Pickup
      # Date (EPD).
      SandboxShipmentUpdates = Structure.new do
        # @return [String] The target shipment status. Mutually exclusive with `subStatus`. Used with
        #   `SHIPMENT_STATUS_CHANGE` update type.
        attribute?(:status, String)

        # @return [String] The target shipment sub-status. Mutually exclusive with `status`. Used with
        #   `SHIPMENT_STATUS_CHANGE` update type.
        attribute?(:sub_status, String, from: "subStatus")

        # @return [Time] The Expected Pickup Date (EPD) for the shipment. Used with `TRANSPORT_CAPACITY_CHANGE` update
        #   type. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
        attribute?(:timestamp, Time)
      end
    end
  end
end
