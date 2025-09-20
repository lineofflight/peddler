# frozen_string_literal: true

require "peddler/types/shipping_v2/item"

module Peddler
  module Types
    module ShippingV2
      # A list of items.
      class ItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Item.parse(item) })
          end
        end
      end
    end
  end
end
