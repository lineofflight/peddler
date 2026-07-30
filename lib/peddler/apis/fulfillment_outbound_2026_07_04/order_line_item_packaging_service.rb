# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Packaging settings for the line item.
      OrderLineItemPackagingService = Structure.new do
        # @return [OrderPackingSlip] Line item packing slip settings. Applying any settings requires that the item has a
        #   printed slip.
        attribute?(:packing_slip, OrderPackingSlip, from: "packingSlip")
      end
    end
  end
end
