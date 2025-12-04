# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class Finances20240619
      # Related business identifiers of the item in the transaction.
      class ItemRelatedIdentifiers < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemRelatedIdentifier.parse(item) })
          end
        end
      end
    end
  end
end
