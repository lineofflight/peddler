# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `listInboundPlans` response.
      ListInboundPlansResponse = Structure.new do
        # A list of inbound plans with minimal information.
        attribute?(:inbound_plans, [InboundPlanSummary], from: "inboundPlans")

        attribute?(:pagination, Pagination)
      end
    end
  end
end
