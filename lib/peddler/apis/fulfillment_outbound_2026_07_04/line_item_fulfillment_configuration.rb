# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Fulfillment service configuration for a line item.
      LineItemFulfillmentConfiguration = Structure.new do
        # @return [OrderLineItemServices] Services for the line item.
        attribute?(:services, OrderLineItemServices)
      end
    end
  end
end
