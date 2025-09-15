# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_v1/shipping_label_request"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # The request schema for the submitShippingLabelRequest operation.
      SubmitShippingLabelsRequest = Structure.new do
        # @return [Array<ShippingLabelRequest>] An array of shipping label requests to be processed.
        attribute(:shipping_label_requests, [ShippingLabelRequest], from: "shippingLabelRequests")
      end
    end
  end
end
