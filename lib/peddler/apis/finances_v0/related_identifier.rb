# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # Related business identifier of the transaction.
      RelatedIdentifier = Structure.new do
        # @return [String] Enumerated set of related business identifier names.
        attribute?(:related_identifier_name, String, from: "RelatedIdentifierName")

        # @return [String] The corresponding value to `RelatedIdentifierName`.
        attribute?(:related_identifier_value, String, from: "RelatedIdentifierValue")
      end
    end
  end
end
