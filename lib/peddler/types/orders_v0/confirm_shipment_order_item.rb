# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module OrdersV0
      # A single order item.
      ConfirmShipmentOrderItem = Structure.new do
        # @return [String] The order item's unique identifier.
        attribute(:order_item_id, String, from: "orderItemId")

        # @return [Integer] The item's quantity.
        attribute(:quantity, Integer)

        # @return [Array<TransparencyCode>] The list of transparency codes.
        attribute?(:transparency_codes, Array, from: "transparencyCodes")
      end
    end
  end
end
