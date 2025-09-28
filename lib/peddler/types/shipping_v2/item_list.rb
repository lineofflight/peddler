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
            array.is_a?(Array) ? new(array.map { |item| Item.parse(item) }) : new
          end
        end
      end
    end
  end
end
