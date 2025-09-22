# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_orders_v1/item_quantity"

module Peddler
  module Types
    module VendorOrdersV1
      # Details of item quantity ordered.
      OrderedQuantityDetails = Structure.new do
        # @return [String] The date when the line item quantity was updated by buyer. Must be in ISO-8601 date/time
        # format.
        attribute(:updated_date, String, from: "updatedDate")

        # @return [ItemQuantity] Item quantity ordered.
        attribute(:ordered_quantity, ItemQuantity, from: "orderedQuantity")

        # @return [ItemQuantity] Item quantity ordered.
        attribute(:cancelled_quantity, ItemQuantity, from: "cancelledQuantity")
      end
    end
  end
end
