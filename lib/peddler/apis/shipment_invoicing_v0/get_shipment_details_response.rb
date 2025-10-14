# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShipmentInvoicingV0
      # The response schema for the getShipmentDetails operation.
      GetShipmentDetailsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [ShipmentDetail] The payload for the getShipmentDetails operation
        attribute?(:payload, ShipmentDetail)
      end
    end
  end
end
