# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # ValidationMetadata Details
      ValidationMetadata = Structure.new do
        # @return [String] errorMessage for the error.
        attribute?(:error_message, String, from: "errorMessage")

        # @return [String] validationStrategy for the error.
        attribute?(:validation_strategy, String, from: "validationStrategy")

        # @return [String] Value.
        attribute?(:value, String)
      end
    end
  end
end
