# frozen_string_literal: true

require "peddler/types/orders_v0/order_item_buyer_info"

module Peddler
  module Types
    module OrdersV0
      # A single order item's buyer information list.
      class OrderItemBuyerInfoList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| OrderItemBuyerInfo.parse(item) })
          end
        end
      end
    end
  end
end
