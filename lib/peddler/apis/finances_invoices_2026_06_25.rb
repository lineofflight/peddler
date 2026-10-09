# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Invoices
    #
    # The Selling Partner API for Invoices enables you to retrieve invoice data and streamline your bookkeeping
    # processes.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/finances-api-model/financesInvoices_2026-06-25.json
    module FinancesInvoices20260625
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "finances_invoices_2026_06_25.get_invoice" => -> { GetInvoiceResponse },
        "finances_invoices_2026_06_25.get_invoice_headers" => -> { GetInvoicesResponse },
      })
    end
  end
end
