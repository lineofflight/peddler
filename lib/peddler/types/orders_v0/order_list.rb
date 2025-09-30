# frozen_string_literal: true

require "peddler/types/orders_v0/order"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module OrdersV0
      # A list of orders.
      class OrderList < Array
        class << self
          def parse(array)
            new(array.map { |item| Order.parse(item) })
          end
        end
      end
    end
  end
end
