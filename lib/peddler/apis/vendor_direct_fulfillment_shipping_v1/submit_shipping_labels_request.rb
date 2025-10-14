# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # The request schema for the submitShippingLabelRequest operation.
      SubmitShippingLabelsRequest = Structure.new do
        # @return [Array<ShippingLabelRequest>] An array of shipping label requests to be processed.
        attribute?(:shipping_label_requests, [ShippingLabelRequest], from: "shippingLabelRequests")
      end
    end
  end
end
