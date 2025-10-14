# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
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
