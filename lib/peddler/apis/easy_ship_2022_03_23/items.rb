# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class EasyShip20220323
      # A list of items contained in the package.
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
