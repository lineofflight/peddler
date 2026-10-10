# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20201201
      # Identifier associated with the item in the Amazon catalog, such as a UPC or EAN identifier.
      ItemIdentifier = Structure.new do
        # Identifier.
        attribute(:identifier, String, null: false)

        # Type of identifier, such as UPC, EAN, or ISBN.
        attribute(:identifier_type, String, null: false, from: "identifierType")
      end
    end
  end
end
