# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductFeesV0
      # An unexpected error occurred during this operation.
      FeesEstimateError = Structure.new do
        # @return [String] An error code that identifies the type of error that occurred.
        attribute(:code, String, from: "Code")

        # @return [Array<Object>]
        attribute(:detail, Array, from: "Detail")

        # @return [String] A message that describes the error condition.
        attribute(:message, String, from: "Message")

        # @return [String] An error type, identifying either the receiver or the sender as the originator of the error.
        attribute(:type, String, from: "Type")
      end
    end
  end
end
