# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Information about the line item being confirmed or rejected.
      LineItem = Structure.new do
        # @return [String] The identifier of the line item from the shipment that is being confirmed or rejected by the
        #   seller.
        attribute(:id, String, null: false)

        # @return [Integer] The quantity of the line item.
        attribute?(:quantity, Integer)
      end
    end
  end
end
