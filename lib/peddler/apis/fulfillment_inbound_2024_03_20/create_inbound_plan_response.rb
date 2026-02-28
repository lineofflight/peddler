# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `createInboundPlan` response.
      CreateInboundPlanResponse = Structure.new do
        # @return [String] Identifier of an inbound plan.
        attribute(:inbound_plan_id, String, null: false, from: "inboundPlanId")

        # @return [String] UUID for the given operation.
        attribute(:operation_id, String, null: false, from: "operationId")
      end
    end
  end
end
