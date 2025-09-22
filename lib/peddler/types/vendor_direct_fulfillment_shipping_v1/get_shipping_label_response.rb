# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/shipping_label"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # The response schema for the getShippingLabel operation.
      GetShippingLabelResponse = Structure.new do
        # @return [ShippingLabel] The payload for the getShippingLabel operation.
        attribute(:payload, ShippingLabel)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
