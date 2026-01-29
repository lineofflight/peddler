# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Order details.
      GetOrderResponse = Structure.new do
        # @return [Order] All available information about the requested order.
        attribute(:order, Order)
      end
    end
  end
end
