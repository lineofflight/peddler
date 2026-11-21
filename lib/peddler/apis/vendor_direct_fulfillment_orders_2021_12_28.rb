# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Direct Fulfillment Orders
    #
    # The Selling Partner API for Direct Fulfillment Orders provides programmatic access to a direct fulfillment
    # vendor's order data.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-orders-api-model/vendorDirectFulfillmentOrders_2021-12-28.json
    module VendorDirectFulfillmentOrders20211228
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "vendor_direct_fulfillment_orders_2021_12_28.get_order" => -> { Order },
        "vendor_direct_fulfillment_orders_2021_12_28.get_orders" => -> { OrderList },
        "vendor_direct_fulfillment_orders_2021_12_28.submit_acknowledgement" => -> { TransactionId },
      })
    end
  end
end
