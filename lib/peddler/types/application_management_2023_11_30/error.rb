# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ApplicationManagement20231130
      # Error response returned when the request is unsuccessful.
      Error = Structure.new do
        # @return [String] An error code that identifies the type of error that occurred.
        attribute(:code, String)

        # @return [String] A message that describes the error condition.
        attribute(:message, String)

        # @return [String] Additional details that can help the caller understand or fix the issue.
        attribute?(:details, String)
      end
    end
  end
end
