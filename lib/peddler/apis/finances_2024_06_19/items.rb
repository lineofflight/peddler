# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class Finances20240619
      # A list of items in the transaction.
      class Items < Array
        class << self
          def parse(array)
            new(array.map { |item| Item.parse(item) })
          end
        end
      end
    end
  end
end
