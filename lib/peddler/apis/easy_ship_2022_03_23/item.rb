# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class EasyShip20220323
      # Item identifier and serial number information.
      Item = Structure.new do
        # @return [String]
        attribute?(:order_item_id, String, from: "orderItemId")

        # @return [Array<OrderItemSerialNumber>]
        attribute?(:order_item_serial_numbers, Array, from: "orderItemSerialNumbers")
      end
    end
  end
end
