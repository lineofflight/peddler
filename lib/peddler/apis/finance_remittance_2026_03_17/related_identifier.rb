# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinanceRemittance20260317
      # A related business identifier for the transaction.
      RelatedIdentifier = Structure.new do
        # An enumerated set of related business identifier names.
        attribute(:related_identifier_name, String, null: false, from: "relatedIdentifierName")

        # The corresponding values for `relatedIdentifierName`.
        attribute(:related_identifier_value, [String], null: false, from: "relatedIdentifierValue")
      end
    end
  end
end
