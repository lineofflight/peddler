# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Retail Procurement Payments
    #
    # The Selling Partner API for Retail Procurement Payments provides programmatic access to vendors payments data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-invoices-api-model/vendorInvoices.json
    module VendorInvoicesV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "vendor_invoices_v1.submit_invoices" => -> { SubmitInvoicesResponse },
      })
    end
  end
end
