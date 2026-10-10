# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # The response schema for `getOrderPreview`.
      GetOrderPreviewResponse = Structure.new do
        # An array of planned shipment information.
        attribute(:planned_shipments, [PreviewPlannedShipment], null: false, from: "plannedShipments")

        # An array of constraints that may affect the fulfillment order.
        attribute?(:constraints, [Constraint])
      end
    end
  end
end
