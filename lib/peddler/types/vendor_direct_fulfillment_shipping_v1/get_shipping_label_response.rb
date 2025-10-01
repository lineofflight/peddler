# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/shipping_label"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
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
