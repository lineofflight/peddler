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
      # @param [Hash] body The request body containing the invoice data to submit.
      # @return [Hash] The API response
      def submit_invoices(body)
        path = "/vendor/payments/v1/invoices"
        body = body

        rate_limit(0.1).post(path, body:)
      end
    end
  end
end
