# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/shipping_label_list"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # The response schema for the getShippingLabels operation.
      GetShippingLabelListResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [ShippingLabelList] List of ship labels.
        attribute?(:payload, ShippingLabelList)
      end
    end
  end
end
