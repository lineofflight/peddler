# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/retrieve_shipping_label_result"
require "peddler/types/shipping_v1/error"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the retrieveShippingLabel operation.
      RetrieveShippingLabelResponse = Structure.new do
        # @return [RetrieveShippingLabelResult] The payload for retrieveShippingLabel operation
        attribute?(:payload, RetrieveShippingLabelResult)

        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
