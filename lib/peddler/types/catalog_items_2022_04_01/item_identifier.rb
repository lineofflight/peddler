# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module CatalogItems20220401
      # The identifier that is associated with the item in the Amazon catalog, such as a UPC or EAN identifier.
      ItemIdentifier = Structure.new do
        # @return [String] Identifier of the item.
        attribute(:identifier, String)

        # @return [String] Type of identifier, such as UPC, EAN, or ISBN.
        attribute(:identifier_type, String, from: "identifierType")
      end
    end
  end
end
