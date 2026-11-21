# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductFeesV0
      # An unexpected error occurred during this operation.
      FeesEstimateError = Structure.new do
        # An error code that identifies the type of error that occurred.
        attribute(:code, String, null: false, from: "Code")

        attribute(:detail, Array, null: false, from: "Detail")

        # A message that describes the error condition.
        attribute(:message, String, null: false, from: "Message")

        # An error type, identifying either the receiver or the sender as the originator of the error.
        attribute(:type, String, null: false, from: "Type")
      end
    end
  end
end
