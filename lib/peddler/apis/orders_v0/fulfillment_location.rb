# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Represents a location from which the plan is to be fulfilled.
      FulfillmentLocation = Structure.new do
        # @return [String] The fulfillment location identifier.
        attribute?(:supply_source_id, String, from: "SupplySourceId")
      end
    end
  end
end
