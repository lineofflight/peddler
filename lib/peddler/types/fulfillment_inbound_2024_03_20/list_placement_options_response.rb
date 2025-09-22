# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/pagination"
require "peddler/types/fulfillment_inbound_2024_03_20/placement_option"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listPlacementOptions` response.
      ListPlacementOptionsResponse = Structure.new do
        # @return [Pagination]
        attribute(:pagination, Pagination)

        # @return [Array<PlacementOption>] Placement options generated for the inbound plan.
        attribute(:placement_options, [PlacementOption], from: "placementOptions")
      end
    end
  end
end
