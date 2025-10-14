# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ListingsItems20210801
      # Identity attributes associated with the item in the Amazon catalog, such as the ASIN.
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
