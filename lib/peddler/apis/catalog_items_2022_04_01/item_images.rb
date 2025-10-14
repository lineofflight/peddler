# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20220401
      # The images for an item in the Amazon catalog.
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
