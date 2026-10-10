# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Individual order item contained within a shipping package.
      PackageItem = Structure.new do
        # Unique identifier of the order item included in this package.
        attribute(:order_item_id, String, null: false, from: "orderItemId")

        # Number of units of this item included in the package shipment.
        attribute(:quantity, Integer, null: false)

        # The transparency codes associated with this item for product authentication.
        attribute?(:transparency_codes, [String], from: "transparencyCodes")
      end
    end
  end
end
