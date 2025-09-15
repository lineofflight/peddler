# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `updateShipmentName` request.
      UpdateShipmentNameRequest = Structure.new do
        # @return [String] A human-readable name to update the shipment name to.
        attribute(:name, String)
      end
    end
  end
end
