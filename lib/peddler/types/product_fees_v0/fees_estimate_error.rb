# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductFeesV0
      # An unexpected error occurred during this operation.
      FeesEstimateError = Structure.new do
        # @return [String] An error type, identifying either the receiver or the sender as the originator of the error.
        attribute(:type, String, from: "Type")

        # @return [String] An error code that identifies the type of error that occurred.
        attribute(:code, String, from: "Code")

        # @return [String] A message that describes the error condition.
        attribute(:message, String, from: "Message")

        # @return [Array]
        attribute(:detail, Array, from: "Detail")
      end
    end
  end
end
