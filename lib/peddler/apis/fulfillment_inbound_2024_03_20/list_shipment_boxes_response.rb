# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `listShipmentBoxes` response.
      ListShipmentBoxesResponse = Structure.new do
        # @return [Array<Box>] A list of boxes in a shipment.
        attribute(:boxes, [Box], null: false)

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
