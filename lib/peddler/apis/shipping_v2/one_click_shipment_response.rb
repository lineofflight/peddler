# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The response schema for the OneClickShipment operation.
      OneClickShipmentResponse = Structure.new do
        # @return [OneClickShipmentResult]
        attribute?(:payload, OneClickShipmentResult)
      end
    end
  end
end
