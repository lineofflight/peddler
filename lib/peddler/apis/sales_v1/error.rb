# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SalesV1
      # Error response returned when the request is unsuccessful.
      Error = Structure.new do
        # An error code that identifies the type of error that occured.
        attribute(:code, String, null: false)

        # A message that describes the error condition in a human-readable form.
        attribute(:message, String, null: false)

        # Additional details that can help the caller understand or fix the issue.
        attribute?(:details, String)
      end
    end
  end
end
