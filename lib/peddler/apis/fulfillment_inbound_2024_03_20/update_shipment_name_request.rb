# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `updateShipmentName` request.
      UpdateShipmentNameRequest = Structure.new do
        # @return [String] A human-readable name to update the shipment name to.
        attribute(:name, String)
      end
    end
  end
end
