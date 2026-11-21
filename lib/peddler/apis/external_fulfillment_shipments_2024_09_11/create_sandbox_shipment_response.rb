# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # The response object for creating a sandbox shipment.
      CreateSandboxShipmentResponse = Structure.new do
        # The identifier of the created sandbox shipment.
        attribute?(:shipment_id, String, from: "shipmentId")
      end
    end
  end
end
