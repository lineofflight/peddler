# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/inbound_plan_summary"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listInboundPlans` response.
      ListInboundPlansResponse = Structure.new do
        # @return [Array<InboundPlanSummary>] A list of inbound plans with minimal information.
        attribute?(:inbound_plans, [InboundPlanSummary], from: "inboundPlans")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
