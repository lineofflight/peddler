# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
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
