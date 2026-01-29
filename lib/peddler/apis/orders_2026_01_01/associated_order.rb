# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Another order that has a direct business relationship with the current order, such as replacements or exchanges.
      AssociatedOrder = Structure.new do
        # @return [String] The relationship between the current order and the associated order.
        #
        # **Possible values**: `REPLACEMENT_ORIGINAL_ID`, `EXCHANGE_ORIGINAL_ID`
        attribute?(:association_type, String, from: "associationType")

        # @return [String] The unique identifier of the related order that is associated with the current order.
        attribute?(:order_id, String, from: "orderId")
      end
    end
  end
end
