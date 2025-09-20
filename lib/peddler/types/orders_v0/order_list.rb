# frozen_string_literal: true

require "peddler/types/orders_v0/order"

module Peddler
  module Types
    module OrdersV0
      # A list of orders.
      class OrderList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Order.parse(item) })
          end
        end
      end
    end
  end
end
