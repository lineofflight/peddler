# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Information related to the packaging process for an order item.
      ItemPacking = Structure.new do
        # @return [GiftOption] Gift wrapping and messaging specified for this item.
        attribute?(:gift_option, GiftOption, from: "giftOption")
      end
    end
  end
end
