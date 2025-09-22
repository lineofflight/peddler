# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/custom_placement_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `generatePlacementOptions` request.
      GeneratePlacementOptionsRequest = Structure.new do
        # @return [Array<CustomPlacementInput>] Custom placement options you want to add to the plan. This is only used
        # for the India (IN - A21TJRUUN4KGV) marketplace.
        attribute(:custom_placement, [CustomPlacementInput], from: "customPlacement")
      end
    end
  end
end
