# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # The response schema for the getShippingLabel operation.
      GetShippingLabelResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [ShippingLabel] The payload for the getShippingLabel operation.
        attribute?(:payload, ShippingLabel)
      end
    end
  end
end
