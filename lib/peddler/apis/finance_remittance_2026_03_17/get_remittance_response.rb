# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinanceRemittance20260317
      # The response for the `getRemittance` operation.
      GetRemittanceResponse = Structure.new do
        # @return [String] A token to fetch the next page of line item results. Present when more results are available.
        attribute?(:next_token_for_line_items, String, from: "nextTokenForLineItems")

        # @return [RemittanceHeader] The remittance header information.
        attribute?(:remittance_header, RemittanceHeader, from: "remittanceHeader")

        # @return [Array<RemittanceItem>] A list of remittance line items.
        attribute?(:remittance_items, [RemittanceItem], from: "remittanceItems")
      end
    end
  end
end
