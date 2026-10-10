# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Invoices20240619
      # The identifier for a transaction.
      TransactionIdentifier = Structure.new do
        # The transaction identifier.
        attribute?(:id, String)

        # The transaction identifier name. Use the `getInvoicesAttributes` operation to check
        # `transactionIdentifierName` options.
        attribute?(:name, String)
      end
    end
  end
end
