# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/item"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listPackingGroupItems` response.
      ListPackingGroupItemsResponse = Structure.new do
        # @return [Array<Item>] Provides the information about the list of items in the packing group.
        attribute(:items, [Item])

        # @return [Pagination]
        attribute(:pagination, Pagination)
      end
    end
  end
end
