# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/shipping_label_request"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # The request schema for the `submitShippingLabelRequest` operation.
      SubmitShippingLabelsRequest = Structure.new do
        # @return [Array<ShippingLabelRequest>] An array of shipping label requests to be processed.
        attribute?(:shipping_label_requests, [ShippingLabelRequest], from: "shippingLabelRequests")
      end
    end
  end
end
