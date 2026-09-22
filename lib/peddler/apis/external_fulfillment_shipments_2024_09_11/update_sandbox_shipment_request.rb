# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The request object for updating a sandbox shipment. The `updates` object is required for
      # `SHIPMENT_STATUS_CHANGE` and `TRANSPORT_CAPACITY_CHANGE` update types, and must not be provided for
      # `INVOICE_AVAILABILITY_CHANGE`.
      UpdateSandboxShipmentRequest = Structure.new do
        # @return [String] The type of update to apply to the shipment.
        attribute(:update_type, String, null: false, from: "updateType")

        # @return [SandboxShipmentUpdates]
        attribute?(:updates, SandboxShipmentUpdates)
      end
    end
  end
end
