# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # The identifier for a transaction.
      TransactionIdentifier = Structure.new do
        # @return [String] The transaction identifier.
        attribute?(:id, String)

        # @return [String] The transaction identifier name. Use the `getInvoicesAttributes` operation to check
        #   `transactionIdentifierName` options.
        attribute?(:name, String)
      end
    end
  end
end
