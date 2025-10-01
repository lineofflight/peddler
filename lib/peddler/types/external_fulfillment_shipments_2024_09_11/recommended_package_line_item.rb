# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # A line item to be contained in a recommended package. This attribute is provided only for orders that come with
      # a specific recommendation of line-item distribution within the package recommendations.
      RecommendedPackageLineItem = Structure.new do
        # @return [String] An ID for a line item in an order. The line item should be present in the recommended
        # package. This identifier has the same value as the ID of the line item present in the order.
        attribute(:line_item_id, String, from: "lineItemId")
      end
    end
  end
end
