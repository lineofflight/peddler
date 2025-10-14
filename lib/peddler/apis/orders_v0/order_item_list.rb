# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class OrdersV0
      # A list of order items.
      class OrderItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| OrderItem.parse(item) })
          end
        end
      end
    end
  end
end
