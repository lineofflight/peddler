# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20201201
      # Images for an item in the Amazon catalog. All image variants are provided to brand owners. Otherwise, a
      # thumbnail of the "MAIN" image variant is provided.
      class ItemImages < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemImagesByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
