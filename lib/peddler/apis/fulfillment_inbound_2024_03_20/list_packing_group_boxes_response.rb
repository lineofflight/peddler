# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `listPackingGroupBoxes` response.
      ListPackingGroupBoxesResponse = Structure.new do
        # Provides the information about the list of boxes in the packing group.
        attribute(:boxes, [Box], null: false)

        attribute?(:pagination, Pagination)
      end
    end
  end
end
