# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # Response payload with the list of shipping labels
      ShippingLabelList = Structure.new do
        # @return [Pagination]
        attribute?(:pagination, Pagination)

        # @return [Array<ShippingLabel>] An array containing the details of the generated shipping labels.
        attribute?(:shipping_labels, [ShippingLabel], from: "shippingLabels")
      end
    end
  end
end
