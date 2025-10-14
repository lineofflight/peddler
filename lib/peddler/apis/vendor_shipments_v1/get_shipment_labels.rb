# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # The response schema for the GetShipmentLabels operation.
      GetShipmentLabels = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [TransportationLabels]
        attribute?(:payload, TransportationLabels)
      end
    end
  end
end
