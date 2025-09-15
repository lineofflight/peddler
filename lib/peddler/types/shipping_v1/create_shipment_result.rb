# frozen_string_literal: true

require "peddler/types/shipping_v1/rate"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the createShipment operation.
      CreateShipmentResult = Structure.new do
        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [Array<Rate>]
        attribute(:eligible_rates, [Rate], from: "eligibleRates")
      end
    end
  end
end
