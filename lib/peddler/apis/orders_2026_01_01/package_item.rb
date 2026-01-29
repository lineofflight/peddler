# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Individual order item contained within a shipping package.
      PackageItem = Structure.new do
        # @return [String] Unique identifier of the order item included in this package.
        attribute(:order_item_id, String, from: "orderItemId")

        # @return [Integer] Number of units of this item included in the package shipment.
        attribute(:quantity, Integer)

        # @return [Array<String>] The transparency codes associated with this item for product authentication.
        attribute?(:transparency_codes, [String], from: "transparencyCodes")
      end
    end
  end
end
