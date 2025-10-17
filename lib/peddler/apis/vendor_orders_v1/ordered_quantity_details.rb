# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorOrdersV1
      # Details of item quantity ordered.
      OrderedQuantityDetails = Structure.new do
        # @return [ItemQuantity] Item quantity ordered.
        attribute?(:cancelled_quantity, ItemQuantity, from: "cancelledQuantity")

        # @return [ItemQuantity] Item quantity ordered.
        attribute?(:ordered_quantity, ItemQuantity, from: "orderedQuantity")

        # @return [Time] The date when the line item quantity was updated by buyer. Must be in ISO-8601 date/time
        #   format.
        attribute?(:updated_date, Time, from: "updatedDate")
      end
    end
  end
end
