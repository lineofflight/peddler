# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The response schema for the retrieveShippingLabel operation.
      RetrieveShippingLabelResponse = Structure.new do
        # Encountered errors for the operation.
        attribute?(:errors, [Error])

        # The payload for retrieveShippingLabel operation
        attribute?(:payload, RetrieveShippingLabelResult)
      end
    end
  end
end
