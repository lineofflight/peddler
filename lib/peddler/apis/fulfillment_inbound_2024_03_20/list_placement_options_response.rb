# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `listPlacementOptions` response.
      ListPlacementOptionsResponse = Structure.new do
        # @return [Array<PlacementOption>] Placement options generated for the inbound plan.
        attribute(:placement_options, [PlacementOption], from: "placementOptions")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
