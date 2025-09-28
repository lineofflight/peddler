# frozen_string_literal: true

require "peddler/types/orders_v0/order_item_buyer_info"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module OrdersV0
      # A single order item's buyer information list.
      class OrderItemBuyerInfoList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| OrderItemBuyerInfo.parse(item) }) : new
          end
        end
      end
    end
  end
end
