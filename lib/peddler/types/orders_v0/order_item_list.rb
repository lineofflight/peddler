# frozen_string_literal: true

require "peddler/types/orders_v0/order_item"

module Peddler
  module Types
    module OrdersV0
      # A list of order items.
      class OrderItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| OrderItem.parse(item) })
          end
        end
      end
    end
  end
end
