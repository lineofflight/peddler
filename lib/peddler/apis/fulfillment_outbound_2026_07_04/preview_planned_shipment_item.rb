# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Item information for a fulfillment preview.
      PreviewPlannedShipmentItem = Structure.new do
        # @return [Amount]
        attribute(:amount, Amount, null: false)

        # @return [ProductIdentifier]
        attribute(:product_identifier, ProductIdentifier, null: false, from: "productIdentifier")
      end
    end
  end
end
