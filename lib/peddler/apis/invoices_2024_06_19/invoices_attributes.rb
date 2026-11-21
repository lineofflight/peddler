# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Invoices20240619
      # An object that contains the invoice attributes definition.
      InvoicesAttributes = Structure.new do
        # A list of all the options that are available for the invoice status attribute.
        attribute?(:invoice_status_options, [AttributeOption], from: "invoiceStatusOptions")

        # A list of all the options that are available for the invoice type attribute.
        attribute?(:invoice_type_options, [AttributeOption], from: "invoiceTypeOptions")

        # A list of all the options that are available for the transaction identifier name attribute.
        attribute?(:transaction_identifier_name_options, [AttributeOption], from: "transactionIdentifierNameOptions")

        # A list of all the options that are available for the transaction type attribute.
        attribute?(:transaction_type_options, [AttributeOption], from: "transactionTypeOptions")
      end
    end
  end
end
