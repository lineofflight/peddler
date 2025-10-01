# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/error"
require "peddler/types/shipping_v1/retrieve_shipping_label_result"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the retrieveShippingLabel operation.
      RetrieveShippingLabelResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])

        # @return [RetrieveShippingLabelResult] The payload for retrieveShippingLabel operation
        attribute?(:payload, RetrieveShippingLabelResult)
      end
    end
  end
end
