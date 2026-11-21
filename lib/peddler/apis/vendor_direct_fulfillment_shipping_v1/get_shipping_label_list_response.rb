# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShippingV1
      # The response schema for the getShippingLabels operation.
      GetShippingLabelListResponse = Structure.new do
        attribute?(:errors, [Error])

        # List of ship labels.
        attribute?(:payload, ShippingLabelList)
      end
    end
  end
end
