# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Direct Fulfillment Payments
    #
    # The Selling Partner API for Direct Fulfillment Payments provides programmatic access to a direct fulfillment
    # vendor's invoice data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-payments-api-model/vendorDirectFulfillmentPaymentsV1.json
    class VendorDirectFulfillmentPaymentsV1 < API
      # Submits one or more invoices for a vendor's direct fulfillment orders.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body containing one or more invoices for vendor orders.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_invoice(body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/payments/v1/invoices"
        parser = -> { SubmitInvoiceResponse }
        post(path, body:, rate_limit:, parser:)
      end
    end
  end
end
