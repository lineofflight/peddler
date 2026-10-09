# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Retail Procurement Orders
    #
    # The Selling Partner API for Retail Procurement Orders provides programmatic access to vendor orders data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-orders-api-model/vendorOrders.json
    module VendorOrdersV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "vendor_orders_v1.get_purchase_order" => -> { GetPurchaseOrderResponse },
        "vendor_orders_v1.get_purchase_orders" => -> { GetPurchaseOrdersResponse },
        "vendor_orders_v1.get_purchase_orders_status" => -> { GetPurchaseOrdersStatusResponse },
        "vendor_orders_v1.submit_acknowledgement" => -> { SubmitAcknowledgementResponse },
      })
    end
  end
end
