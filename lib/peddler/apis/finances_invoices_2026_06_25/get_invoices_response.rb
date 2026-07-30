# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # The response to the `getInvoiceHeaders` operation.
      GetInvoicesResponse = Structure.new do
        # @return [Array<InvoiceHeader>] A list of invoices with header-level details.
        attribute?(:invoices, [InvoiceHeader])

        # @return [String] The response includes `nextToken` when the number of invoices exceeds the default page size
        #   value. To get the next page of results, call the operation with this token and include the same arguments as
        #   the call that produced the token. To get a complete list, call this operation until `nextToken` is `null`.
        #   Note that this operation can return empty pages.
        attribute?(:next_token, String, from: "nextToken")

        # @return [Integer] The number of records returned.
        attribute?(:num_of_records, Integer, from: "numOfRecords")
      end
    end
  end
end
