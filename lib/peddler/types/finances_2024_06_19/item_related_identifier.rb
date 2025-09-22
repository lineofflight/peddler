# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Related business identifiers of the item.
      ItemRelatedIdentifier = Structure.new do
        # @return [String] Enumerated set of related item identifier names for the item.
        attribute(:item_related_identifier_name, String, from: "itemRelatedIdentifierName")

        # @return [String] Corresponding value of ItemRelatedIdentifierName
        attribute(:item_related_identifier_value, String, from: "itemRelatedIdentifierValue")
      end
    end
  end
end
