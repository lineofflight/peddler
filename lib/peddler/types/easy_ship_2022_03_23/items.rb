# frozen_string_literal: true

require "peddler/types/easy_ship_2022_03_23/item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module EasyShip20220323
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
