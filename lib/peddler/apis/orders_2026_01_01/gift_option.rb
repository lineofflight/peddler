# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Gift wrapping and personalization options selected by the customer for an order item.
      GiftOption = Structure.new do
        # @return [String] Personal message from the buyer to be included with the gift-wrapped item.
        attribute?(:gift_message, String, from: "giftMessage")

        # @return [String] Type or quality level of gift wrapping service selected by the customer.
        attribute?(:gift_wrap_level, String, from: "giftWrapLevel")
      end
    end
  end
end
