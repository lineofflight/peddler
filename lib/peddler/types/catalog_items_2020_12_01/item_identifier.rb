# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CatalogItems20201201
      # Identifier associated with the item in the Amazon catalog, such as a UPC or EAN identifier.
      ItemIdentifier = Structure.new do
        # @return [String] Type of identifier, such as UPC, EAN, or ISBN.
        attribute(:identifier_type, String, from: "identifierType")

        # @return [String] Identifier.
        attribute(:identifier, String)
      end
    end
  end
end
