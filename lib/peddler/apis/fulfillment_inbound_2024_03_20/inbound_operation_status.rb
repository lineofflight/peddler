# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # GetInboundOperationStatus response.
      InboundOperationStatus = Structure.new do
        # @return [String] The name of the operation in the asynchronous API call.
        attribute(:operation, String, null: false)

        # @return [String] The operation ID returned by the asynchronous API call.
        attribute(:operation_id, String, null: false, from: "operationId")

        # @return [Array<OperationProblem>] The problems in the processing of the asynchronous operation.
        attribute(:operation_problems, [OperationProblem], null: false, from: "operationProblems")

        # @return [String]
        attribute(:operation_status, String, null: false, from: "operationStatus")
      end
    end
  end
end
