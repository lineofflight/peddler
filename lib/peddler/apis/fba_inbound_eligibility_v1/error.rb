# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInboundEligibilityV1
      # Error response returned when the request is unsuccessful.
      Error = Structure.new do
        # @return [String] An error code that identifies the type of error that occurred.
        attribute(:code, String, null: false)

        # @return [String] Additional information that can help the caller understand or fix the issue.
        attribute?(:details, String)

        # @return [String] A message that describes the error condition in a human-readable form.
        attribute?(:message, String)
      end
    end
  end
end
