# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Item identifiers for an item in a direct fulfillment shipment.
      DirectFulfillmentItemIdentifiers = Structure.new do
        # @return [String] A unique identifier for an item provided by the client for a direct fulfillment shipment.
        #   This is only populated for direct fulfillment multi-piece shipments. It is required if a vendor wants to
        #   change the configuration of the packages in which the purchase order is shipped.
        attribute(:line_item_id, String, from: "lineItemID")

        # @return [String] A unique identifier for an item provided by the client for a direct fulfillment shipment.
        #   This is only populated if a single line item has multiple pieces. Defaults to 1.
        attribute?(:piece_number, String, from: "pieceNumber")
      end
    end
  end
end
