# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module OrdersV0
      # Contains the instructions about the fulfillment, such as the location from where you want the order filled.
      FulfillmentInstruction = Structure.new do
        # @return [String] The `sourceId` of the location from where you want the order fulfilled.
        attribute(:fulfillment_supply_source_id, String, from: "FulfillmentSupplySourceId")
      end
    end
  end
end
