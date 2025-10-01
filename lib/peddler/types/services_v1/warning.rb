# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Warning returned when the request is successful, but there are important callouts based on which API clients
      # should take defined actions.
      Warning = Structure.new do
        # @return [String] An warning code that identifies the type of warning that occurred.
        attribute(:code, String)

        # @return [String] A message that describes the warning condition in a human-readable form.
        attribute(:message, String)

        # @return [String] Additional details that can help the caller understand or address the warning.
        attribute?(:details, String)
      end
    end
  end
end
