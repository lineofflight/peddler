# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/invoices_2024_06_19/export"

module Peddler
  module Types
    module Invoices20240619
      # Success.
      GetInvoicesExportsResponse = Structure.new do
        # @return [Array<Export>] A list of exports.
        attribute?(:exports, [Export])

        # @return [String] This token is returned when the number of results exceeds the specified `pageSize` value. To
        # get the next page of results, call the `getInvoices` operation and include this token with the previous call
        # parameters.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
