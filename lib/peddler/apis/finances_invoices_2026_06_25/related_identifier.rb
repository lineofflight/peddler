# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # Related business identifier of the transaction.
      RelatedIdentifier = Structure.new do
        # @return [String] The name of the related identifier.
        attribute(:related_identifier_name, String, null: false, from: "relatedIdentifierName")

        # @return [Array<String>] The corresponding related identifier values.
        attribute(:related_identifier_value, [String], null: false, from: "relatedIdentifierValue")
      end
    end
  end
end
