# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_orders_v1/order"
require "peddler/types/vendor_direct_fulfillment_orders_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # The response schema for the getOrder operation.
      GetOrderResponse = Structure.new do
        # @return [Order] The payload for the getOrder operation.
        attribute(:payload, Order)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
