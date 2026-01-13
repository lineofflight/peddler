# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Retail Procurement Payments
    #
    # The Selling Partner API for Retail Procurement Payments provides programmatic access to vendors payments data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-invoices-api-model/vendorInvoices.json
    class VendorInvoicesV1 < API
      # Submit new invoices to Amazon.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body containing the invoice data to submit.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_invoices(body, rate_limit: 10.0)
        path = "/vendor/payments/v1/invoices"
        parser = -> { SubmitInvoicesResponse }
        post(path, body:, rate_limit:, parser:)
      end
    end
  end
end
