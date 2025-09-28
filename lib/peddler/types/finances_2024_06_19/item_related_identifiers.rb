# frozen_string_literal: true

require "peddler/types/finances_2024_06_19/item_related_identifier"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module Finances20240619
      # Related Business identifiers of the item in Transaction.
      class ItemRelatedIdentifiers < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ItemRelatedIdentifier.parse(item) }) : new
          end
        end
      end
    end
  end
end
