# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItems20220401
      # Product types that are associated with the Amazon catalog item.
      class ItemProductTypes < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemProductTypeByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
