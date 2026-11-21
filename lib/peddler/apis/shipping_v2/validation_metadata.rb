# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # ValidationMetadata Details
      ValidationMetadata = Structure.new do
        # errorMessage for the error.
        attribute?(:error_message, String, from: "errorMessage")

        # validationStrategy for the error.
        attribute?(:validation_strategy, String, from: "validationStrategy")

        # Value.
        attribute?(:value, String)
      end
    end
  end
end
