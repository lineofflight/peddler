# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def vendor_direct_fulfillment_payments_v1(...)
      APIs::VendorDirectFulfillmentPaymentsV1.new(...)
    end
  end

  module APIs
    # Selling Partner API for Direct Fulfillment Payments
    #
    # The Selling Partner API for Direct Fulfillment Payments provides programmatic access to a direct fulfillment
    # vendor's invoice data.
    class VendorDirectFulfillmentPaymentsV1 < API
      # Submits one or more invoices for a vendor's direct fulfillment orders.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body containing one or more invoices for vendor orders.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def submit_invoice(body, rate_limit: 10.0, tries: 2)
        path = "/vendor/directFulfillment/payments/v1/invoices"

        meter(rate_limit, tries:).post(path, body:)
      end
    end
  end
end
