# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # An object that contains the invoice attributes definition.
      InvoicesAttributes = Structure.new do
        # @return [Array<AttributeOption>] A list of all the options that are available for the invoice status
        # attribute.
        attribute?(:invoice_status_options, [AttributeOption], from: "invoiceStatusOptions")

        # @return [Array<AttributeOption>] A list of all the options that are available for the invoice type attribute.
        attribute?(:invoice_type_options, [AttributeOption], from: "invoiceTypeOptions")

        # @return [Array<AttributeOption>] A list of all the options that are available for the transaction identifier
        # name attribute.
        attribute?(:transaction_identifier_name_options, [AttributeOption], from: "transactionIdentifierNameOptions")

        # @return [Array<AttributeOption>] A list of all the options that are available for the transaction type
        # attribute.
        attribute?(:transaction_type_options, [AttributeOption], from: "transactionTypeOptions")
      end
    end
  end
end
