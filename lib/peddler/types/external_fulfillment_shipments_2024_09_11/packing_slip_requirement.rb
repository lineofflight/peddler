# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Whether the packing slip is required to be attached to the shipment, and its corresponding status.
      PackingSlipRequirement = Structure.new do
        # @return [String] Whether the packing slip is required to be attached to the shipment.
        attribute?(:requirement, String)

        # @return [String] The status of the packing slip that is attached to the shipment.
        attribute?(:status, String)
      end
    end
  end
end
