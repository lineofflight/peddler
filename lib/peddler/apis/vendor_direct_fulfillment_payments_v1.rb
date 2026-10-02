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
    module VendorDirectFulfillmentPaymentsV1
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "vendor_direct_fulfillment_payments_v1.submit_invoice" => -> { SubmitInvoiceResponse },
      }.freeze
    end
  end
end
