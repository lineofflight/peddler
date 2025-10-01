# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/packing_slip"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
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
