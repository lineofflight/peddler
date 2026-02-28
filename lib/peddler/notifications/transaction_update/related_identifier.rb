# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TransactionUpdate
      # Related business identifier of the transaction.
      RelatedIdentifier = Structure.new do
        # @return [String] Enumerated set of related business identifier names.
        attribute(:related_identifier_name, String, null: false, from: "RelatedIdentifierName")

        # @return [String] Corresponding value of RelatedIdentifierName
        attribute(:related_identifier_value, String, null: false, from: "RelatedIdentifierValue")
      end
    end
  end
end
