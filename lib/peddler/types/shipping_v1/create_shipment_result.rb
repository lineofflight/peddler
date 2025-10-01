# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/rate"

module Peddler
  module Types
    module ShippingV1
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
