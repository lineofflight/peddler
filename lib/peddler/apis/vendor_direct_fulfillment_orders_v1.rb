# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Direct Fulfillment Orders
    #
    # The Selling Partner API for Direct Fulfillment Orders provides programmatic access to a direct fulfillment
    # vendor's order data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-orders-api-model/vendorDirectFulfillmentOrdersV1.json
    module VendorDirectFulfillmentOrdersV1
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "vendor_direct_fulfillment_orders_v1.get_order" => -> { GetOrderResponse },
        "vendor_direct_fulfillment_orders_v1.get_orders" => -> { GetOrdersResponse },
        "vendor_direct_fulfillment_orders_v1.submit_acknowledgement" => -> { SubmitAcknowledgementResponse },
      }.freeze
    end
  end
end
