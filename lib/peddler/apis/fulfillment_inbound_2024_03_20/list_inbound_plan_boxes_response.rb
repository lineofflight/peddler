# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `listInboundPlanBoxes` response.
      ListInboundPlanBoxesResponse = Structure.new do
        # A list of boxes in an inbound plan.
        attribute(:boxes, [Box], null: false)

        attribute?(:pagination, Pagination)
      end
    end
  end
end
