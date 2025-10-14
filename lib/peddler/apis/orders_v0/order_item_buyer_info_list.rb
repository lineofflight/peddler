# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class OrdersV0
      # A single order item's buyer information list.
      class OrderItemBuyerInfoList < Array
        class << self
          def parse(array)
            new(array.map { |item| OrderItemBuyerInfo.parse(item) })
          end
        end
      end
    end
  end
end
