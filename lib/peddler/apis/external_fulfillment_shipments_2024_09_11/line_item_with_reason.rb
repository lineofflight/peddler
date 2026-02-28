# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Information about the line item being confirmed or rejected and the reason for the rejection.
      LineItemWithReason = Structure.new do
        # @return [LineItem]
        attribute(:line_item, LineItem, null: false, from: "lineItem")

        # @return [String] The reason for the rejection of the line item.
        attribute?(:reason, String)
      end
    end
  end
end
