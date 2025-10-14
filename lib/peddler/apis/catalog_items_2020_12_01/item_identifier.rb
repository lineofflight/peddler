# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20201201
      # Identifier associated with the item in the Amazon catalog, such as a UPC or EAN identifier.
      ItemIdentifier = Structure.new do
        # @return [String] Identifier.
        attribute(:identifier, String)

        # @return [String] Type of identifier, such as UPC, EAN, or ISBN.
        attribute(:identifier_type, String, from: "identifierType")
      end
    end
  end
end
