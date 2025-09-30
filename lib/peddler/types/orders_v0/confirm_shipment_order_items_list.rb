# frozen_string_literal: true

require "peddler/types/orders_v0/confirm_shipment_order_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module OrdersV0
      # A list of order items.
      class ConfirmShipmentOrderItemsList < Array
        class << self
          def parse(array)
            new(array.map { |item| ConfirmShipmentOrderItem.parse(item) })
          end
        end
      end
    end
  end
end
