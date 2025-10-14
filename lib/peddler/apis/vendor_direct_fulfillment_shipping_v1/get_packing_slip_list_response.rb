# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # Response payload with the list of Packing Slips.
      GetPackingSlipListResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [PackingSlipList]
        attribute?(:payload, PackingSlipList)
      end
    end
  end
end
