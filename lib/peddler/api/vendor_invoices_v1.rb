# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Retail Procurement Payments
    #
    # The Selling Partner API for Retail Procurement Payments provides programmatic access to vendors payments data.
    class VendorInvoicesV1 < API
      # Submit new invoices to Amazon.
      #
      # @note This operation can make a static sandbox call.
      # @param [Hash] body The request body containing the invoice data to submit.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def submit_invoices(body, rate_limit: 10.0)
        path = "/vendor/payments/v1/invoices"

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
