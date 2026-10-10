# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShippingV1
      # Response payload with the list of Packing Slips.
      GetPackingSlipListResponse = Structure.new do
        attribute?(:errors, [Error])

        attribute?(:payload, PackingSlipList)
      end
    end
  end
end
