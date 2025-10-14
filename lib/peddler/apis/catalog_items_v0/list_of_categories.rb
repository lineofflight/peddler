# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class CatalogItemsV0
      class ListOfCategories < Array
        class << self
          def parse(array)
            new(array.map { |item| Categories.parse(item) })
          end
        end
      end
    end
  end
end
