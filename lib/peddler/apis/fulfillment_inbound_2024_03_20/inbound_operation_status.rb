# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # GetInboundOperationStatus response.
      InboundOperationStatus = Structure.new do
        # The name of the operation in the asynchronous API call.
        attribute(:operation, String, null: false)

        # The operation ID returned by the asynchronous API call.
        attribute(:operation_id, String, null: false, from: "operationId")

        # The problems in the processing of the asynchronous operation.
        attribute(:operation_problems, [OperationProblem], null: false, from: "operationProblems")

        # Known values: `SUCCESS`, `FAILED`, `IN_PROGRESS`.
        attribute(:operation_status, String, null: false, from: "operationStatus")
      end
    end
  end
end
