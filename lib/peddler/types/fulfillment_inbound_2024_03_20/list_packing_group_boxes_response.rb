# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/box"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listPackingGroupBoxes` response.
      ListPackingGroupBoxesResponse = Structure.new do
        # @return [Array<Box>] Provides the information about the list of boxes in the packing group.
        attribute(:boxes, [Box])

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
