# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/pagination"
require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/shipping_label"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Response payload with the list of shipping labels.
      ShippingLabelList = Structure.new do
        # @return [Pagination]
        attribute(:pagination, Pagination)

        # @return [Array<ShippingLabel>] An array containing the details of the generated shipping labels.
        attribute(:shipping_labels, [ShippingLabel], from: "shippingLabels")
      end
    end
  end
end
