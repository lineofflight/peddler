# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_orders_v1/order"
require "peddler/types/vendor_orders_v1/error"

module Peddler
  module Types
    module VendorOrdersV1
      # The response schema for the getPurchaseOrder operation.
      GetPurchaseOrderResponse = Structure.new do
        # @return [Order] The details of the requested order
        attribute(:payload, Order)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
