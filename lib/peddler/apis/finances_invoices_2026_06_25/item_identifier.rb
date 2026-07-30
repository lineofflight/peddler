# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # Identifier for an item in the invoice line item.
      ItemIdentifier = Structure.new do
        # @return [String] The type of item identifier.
        attribute(:item_identifier_name, String, null: false, from: "itemIdentifierName")

        # @return [String] The value of the item identifier.
        attribute(:item_identifier_value, String, null: false, from: "itemIdentifierValue")
      end
    end
  end
end
