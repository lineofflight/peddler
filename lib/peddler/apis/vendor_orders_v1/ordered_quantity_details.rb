# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module VendorOrdersV1
      # Details of item quantity ordered.
      OrderedQuantityDetails = Structure.new do
        # Item quantity ordered.
        attribute?(:cancelled_quantity, ItemQuantity, from: "cancelledQuantity")

        # Item quantity ordered.
        attribute?(:ordered_quantity, ItemQuantity, from: "orderedQuantity")

        # The date when the line item quantity was updated by buyer. Must be in ISO-8601 date/time format.
        attribute?(:updated_date, Time, from: "updatedDate")
      end
    end
  end
end
