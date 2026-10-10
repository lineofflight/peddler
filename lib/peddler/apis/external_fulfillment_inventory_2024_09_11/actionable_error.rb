# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentInventory20240911
      # Error details you can take action on.
      ActionableError = Structure.new do
        # The secondary level error type.
        attribute?(:error_sub_type, String, from: "errorSubType")

        # The top level error type that may contain multiple error subtypes.
        attribute?(:error_type, String, from: "errorType")
      end
    end
  end
end
