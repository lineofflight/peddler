# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_orders_v1/item_quantity"

module Peddler
  module Types
    module VendorOrdersV1
      # Details of item quantity ordered.
      OrderedQuantityDetails = Structure.new do
        # @return [ItemQuantity] Item quantity ordered.
        attribute?(:cancelled_quantity, ItemQuantity, from: "cancelledQuantity")

        # @return [ItemQuantity] Item quantity ordered.
        attribute?(:ordered_quantity, ItemQuantity, from: "orderedQuantity")

        # @return [String] The date when the line item quantity was updated by buyer. Must be in ISO-8601 date/time
        # format.
        attribute?(:updated_date, String, from: "updatedDate")
      end
    end
  end
end
