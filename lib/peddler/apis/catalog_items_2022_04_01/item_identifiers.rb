# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20220401
      # Identifiers associated with the item in the Amazon catalog, such as UPC and EAN identifiers.
      class ItemIdentifiers < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemIdentifiersByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
