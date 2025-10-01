# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/line_item"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Information about the line item being confirmed or rejected and the reason for the rejection.
      LineItemWithReason = Structure.new do
        # @return [LineItem]
        attribute(:line_item, LineItem, from: "lineItem")

        # @return [String] The reason for the rejection of the line item.
        attribute?(:reason, String)
      end
    end
  end
end
