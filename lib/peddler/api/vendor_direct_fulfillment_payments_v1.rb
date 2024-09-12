# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Direct Fulfillment Payments
    #
    # The Selling Partner API for Direct Fulfillment Payments provides programmatic access to a direct fulfillment
    # vendor's invoice data.
    class VendorDirectFulfillmentPaymentsV1 < API
      # Submits one or more invoices for a vendor's direct fulfillment orders.
      #
      # @param [Hash] body The request body that contains one or more invoices for vendor orders.
      # @return [Hash] The API response
      def submit_invoice(body)
        path = "/vendor/directFulfillment/payments/v1/invoices"
        body = body

        rate_limit(0.1).post(path, body:)
      end
    end
  end
end
