# frozen_string_literal: true

require "peddler/types/shipping_v2/item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of items.
      class ItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| Item.parse(item) })
          end
        end
      end
    end
  end
end
