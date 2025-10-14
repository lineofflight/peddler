# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ListingsItems20210801
      # Relationships for a listing item, by marketplace (for example, variations).
      class ItemRelationships < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemRelationshipsByMarketplace.parse(item) })
          end
        end
      end
    end
  end
end
