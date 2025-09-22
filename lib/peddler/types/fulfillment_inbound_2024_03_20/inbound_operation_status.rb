# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/operation_problem"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # GetInboundOperationStatus response.
      InboundOperationStatus = Structure.new do
        # @return [String] The name of the operation in the asynchronous API call.
        attribute(:operation, String)

        # @return [String] The operation ID returned by the asynchronous API call.
        attribute(:operation_id, String, from: "operationId")

        # @return [Array<OperationProblem>] The problems in the processing of the asynchronous operation.
        attribute(:operation_problems, [OperationProblem], from: "operationProblems")

        # @return [String]
        attribute(:operation_status, String, from: "operationStatus")
      end
    end
  end
end
