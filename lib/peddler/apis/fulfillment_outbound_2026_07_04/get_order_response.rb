# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The response schema for `getOrder`.
      GetOrderResponse = Structure.new do
        # @return [FulfillmentOrder]
        attribute(:order, FulfillmentOrder, null: false)
      end
    end
  end
end
