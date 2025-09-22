# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Invoices20240619
      # The identifier for a transaction.
      TransactionIdentifier = Structure.new do
        # @return [String] The transaction identifier name. Use the `getInvoicesAttributes` operation to check
        # `transactionIdentifierName` options.
        attribute(:name, String)

        # @return [String] The transaction identifier.
        attribute(:id, String)
      end
    end
  end
end
