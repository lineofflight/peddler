# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/one_click_shipment_result"

module Peddler
  module Types
    module ShippingV2
      # The response schema for the OneClickShipment operation.
      OneClickShipmentResponse = Structure.new do
        # @return [OneClickShipmentResult]
        attribute?(:payload, OneClickShipmentResult)
      end
    end
  end
end
