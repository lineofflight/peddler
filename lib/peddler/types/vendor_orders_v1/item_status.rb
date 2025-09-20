# frozen_string_literal: true

require "peddler/types/vendor_orders_v1/order_item_status"

module Peddler
  module Types
    module VendorOrdersV1
      # Detailed description of items order status.
      class ItemStatus < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| OrderItemStatus.parse(item) })
          end
        end
      end
    end
  end
end
