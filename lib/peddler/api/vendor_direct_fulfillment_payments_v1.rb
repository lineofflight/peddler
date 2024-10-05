# frozen_string_literal: true

require "peddler/api"
require "peddler/marketplace"

module Peddler
  class << self
    def vendor_direct_fulfillment_payments_v1(...)
      API::VendorDirectFulfillmentPaymentsV1.new(...)
    end
  end

  class API
    # Selling Partner API for Direct Fulfillment Payments
    #
    # The Selling Partner API for Direct Fulfillment Payments provides programmatic access to a direct fulfillment
    # vendor's invoice data.
    class VendorDirectFulfillmentPaymentsV1 < API
      # Submits one or more invoices for a vendor's direct fulfillment orders.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body that contains one or more invoices for vendor orders.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def submit_invoice(body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/payments/v1/invoices"

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
