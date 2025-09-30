# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/invoices_2024_06_19/invoices_document"

module Peddler
  module Types
    module Invoices20240619
      # Success.
      GetInvoicesDocumentResponse = Structure.new do
        # @return [InvoicesDocument]
        attribute?(:invoices_document, InvoicesDocument, from: "invoicesDocument")
      end
    end
  end
end
