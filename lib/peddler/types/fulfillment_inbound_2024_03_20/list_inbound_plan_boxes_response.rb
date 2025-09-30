# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/box"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listInboundPlanBoxes` response.
      ListInboundPlanBoxesResponse = Structure.new do
        # @return [Array<Box>] A list of boxes in an inbound plan.
        attribute(:boxes, [Box])

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
