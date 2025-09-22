# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/packing_slip"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Response payload with packing slip.
      GetPackingSlipResponse = Structure.new do
        # @return [PackingSlip]
        attribute(:payload, PackingSlip)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
