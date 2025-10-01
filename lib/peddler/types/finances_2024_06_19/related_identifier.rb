# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Related business identifier of the transaction.
      RelatedIdentifier = Structure.new do
        # @return [String] Enumerated set of related business identifier names.
        attribute?(:related_identifier_name, String, from: "relatedIdentifierName")

        # @return [String] Corresponding value of RelatedIdentifierName
        attribute?(:related_identifier_value, String, from: "relatedIdentifierValue")
      end
    end
  end
end
