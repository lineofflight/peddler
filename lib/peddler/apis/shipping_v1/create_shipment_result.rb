# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The payload schema for the createShipment operation.
      CreateShipmentResult = Structure.new do
        # @return [Array<Rate>]
        attribute(:eligible_rates, [Rate], from: "eligibleRates")

        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")
      end
    end
  end
end
