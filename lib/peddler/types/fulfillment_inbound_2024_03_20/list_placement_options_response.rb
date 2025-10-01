# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/placement_option"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
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
