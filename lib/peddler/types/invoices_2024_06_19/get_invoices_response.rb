# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/invoices_2024_06_19/invoice"

module Peddler
  module Types
    module Invoices20240619
      # Success.
      GetInvoicesResponse = Structure.new do
        # @return [Array<Invoice>] A list of invoices.
        attribute?(:invoices, [Invoice])

        # @return [String] This token is returned when the number of results exceeds the specified `pageSize` value. To
        # get the next page of results, call the `getInvoices` operation and include this token with the previous call
        # parameters.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
