# frozen_string_literal: true

require "peddler/api"
require "peddler/marketplace"

module Peddler
  class << self
    def vendor_invoices_v1(...)
      API::VendorInvoicesV1.new(...)
    end
  end

  class API
    # Selling Partner API for Retail Procurement Payments
    #
    # The Selling Partner API for Retail Procurement Payments provides programmatic access to vendors payments data.
    class VendorInvoicesV1 < API
      # Submit new invoices to Amazon.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body containing the invoice data to submit.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def submit_invoices(body, rate_limit: 10.0)
        path = "/vendor/payments/v1/invoices"

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
