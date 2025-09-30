# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
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
