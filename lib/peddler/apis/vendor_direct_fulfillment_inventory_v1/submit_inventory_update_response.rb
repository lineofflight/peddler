# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentInventoryV1
      # The response schema for the submitInventoryUpdate operation.
      SubmitInventoryUpdateResponse = Structure.new do
        attribute?(:errors, [Error])

        # The response payload for the submitInventoryUpdate operation.
        attribute?(:payload, TransactionReference)
      end
    end
  end
end
