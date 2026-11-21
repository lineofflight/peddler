# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Invoices.
    #
    # Use the Selling Partner API for Invoices to retrieve and manage invoice-related operations, which can help selling
    # partners manage their bookkeeping processes.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/invoices-api-model/InvoicesApiModel_2024-06-19.json
    module Invoices20240619
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "invoices_2024_06_19.create_invoices_export" => -> { ExportInvoicesResponse },
        "invoices_2024_06_19.get_government_invoice_document" => -> { GovtInvoiceDocumentResponse },
        "invoices_2024_06_19.get_government_invoice_status" => -> { GovernmentInvoiceStatusResponse },
        "invoices_2024_06_19.get_invoice" => -> { GetInvoiceResponse },
        "invoices_2024_06_19.get_invoices" => -> { GetInvoicesResponse },
        "invoices_2024_06_19.get_invoices_attributes" => -> { GetInvoicesAttributesResponse },
        "invoices_2024_06_19.get_invoices_document" => -> { GetInvoicesDocumentResponse },
        "invoices_2024_06_19.get_invoices_export" => -> { GetInvoicesExportResponse },
        "invoices_2024_06_19.get_invoices_exports" => -> { GetInvoicesExportsResponse },
      })
    end
  end
end
