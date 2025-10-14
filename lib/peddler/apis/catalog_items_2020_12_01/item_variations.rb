# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20201201
      # Variation details by marketplace for an Amazon catalog item (variation relationships).
      class ItemVariations < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemVariationsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
