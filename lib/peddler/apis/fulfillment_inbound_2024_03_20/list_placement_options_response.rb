# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `listPlacementOptions` response.
      ListPlacementOptionsResponse = Structure.new do
        # Placement options generated for the inbound plan.
        attribute(:placement_options, [PlacementOption], null: false, from: "placementOptions")

        attribute?(:pagination, Pagination)
      end
    end
  end
end
