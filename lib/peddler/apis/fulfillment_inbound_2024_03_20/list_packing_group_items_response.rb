# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `listPackingGroupItems` response.
      ListPackingGroupItemsResponse = Structure.new do
        # @return [Array<Item>] Provides the information about the list of items in the packing group.
        attribute(:items, [Item], null: false)

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
