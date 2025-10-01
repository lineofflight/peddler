# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # A problem with additional properties persisted to an operation.
      OperationProblem = Structure.new do
        # @return [String] An error code that identifies the type of error that occurred.
        attribute(:code, String)

        # @return [String] A message that describes the error condition.
        attribute(:message, String)

        # @return [String] The severity of the problem. Possible values: `WARNING`, `ERROR`.
        attribute(:severity, String)

        # @return [String] Additional details that can help the caller understand or fix the issue.
        attribute?(:details, String)
      end
    end
  end
end
