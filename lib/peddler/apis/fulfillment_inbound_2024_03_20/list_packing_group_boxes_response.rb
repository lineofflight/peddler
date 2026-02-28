# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `listPackingGroupBoxes` response.
      ListPackingGroupBoxesResponse = Structure.new do
        # @return [Array<Box>] Provides the information about the list of boxes in the packing group.
        attribute(:boxes, [Box], null: false)

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
