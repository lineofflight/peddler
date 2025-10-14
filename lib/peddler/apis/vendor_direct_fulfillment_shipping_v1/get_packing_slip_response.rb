# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # Response payload with packing slip.
      GetPackingSlipResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [PackingSlip]
        attribute?(:payload, PackingSlip)
      end
    end
  end
end
