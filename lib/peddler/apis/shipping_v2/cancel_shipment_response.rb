# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Response schema for the cancelShipment operation.
      CancelShipmentResponse = Structure.new do
        # @return [Hash]
        attribute?(:payload, Hash)
      end
    end
  end
end
