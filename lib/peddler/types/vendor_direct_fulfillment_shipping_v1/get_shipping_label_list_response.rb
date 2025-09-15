# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_v1/shipping_label_list"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # The response schema for the getShippingLabels operation.
      GetShippingLabelListResponse = Structure.new do
        # @return [ShippingLabelList] List of ship labels.
        attribute(:payload, ShippingLabelList)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
