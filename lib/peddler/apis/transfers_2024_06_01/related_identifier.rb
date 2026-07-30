# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Transfers20240601
      # Related business identifier of the payout.
      RelatedIdentifier = Structure.new do
        # @return [String] An enumerated set of related business identifier names.
        attribute(:related_identifier_name, String, null: false, from: "relatedIdentifierName")

        # @return [String] Corresponding value of `RelatedIdentifierName`.
        attribute(:related_identifier_value, String, null: false, from: "relatedIdentifierValue")
      end
    end
  end
end
