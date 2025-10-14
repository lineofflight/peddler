# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorOrdersV1
      # The response schema for the getPurchaseOrder operation.
      GetPurchaseOrderResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [Order] The details of the requested order
        attribute?(:payload, Order)
      end
    end
  end
end
