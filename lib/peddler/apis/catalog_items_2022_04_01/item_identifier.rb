# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # The identifier that is associated with the item in the Amazon catalog, such as a UPC or EAN identifier.
      ItemIdentifier = Structure.new do
        # @return [String] Identifier of the item.
        attribute(:identifier, String, null: false)

        # @return [String] Type of identifier, such as UPC, EAN, or ISBN.
        attribute(:identifier_type, String, null: false, from: "identifierType")
      end
    end
  end
end
