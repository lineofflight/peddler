# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Error object containing information about what went wrong.
      Error = Structure.new do
        # An error code that identifies the type of error that occurred.
        attribute(:code, String, null: false)

        # A message that describes the error condition.
        attribute(:message, String, null: false)

        # Additional details that can help the caller understand or fix the issue.
        attribute?(:details, String)
      end
    end
  end
end
