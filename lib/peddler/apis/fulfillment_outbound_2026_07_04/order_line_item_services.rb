# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Services selected for a line item.
      OrderLineItemServices = Structure.new do
        # @return [OrderLineItemDeliveryService]
        attribute?(:delivery, OrderLineItemDeliveryService)

        # @return [OrderLineItemPackagingService]
        attribute?(:packaging, OrderLineItemPackagingService)
      end
    end
  end
end
