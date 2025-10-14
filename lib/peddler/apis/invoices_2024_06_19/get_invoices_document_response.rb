# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Success.
      GetInvoicesDocumentResponse = Structure.new do
        # @return [InvoicesDocument]
        attribute?(:invoices_document, InvoicesDocument, from: "invoicesDocument")
      end
    end
  end
end
