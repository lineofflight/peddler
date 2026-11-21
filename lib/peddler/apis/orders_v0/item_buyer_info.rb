# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # A single item's buyer information.
      ItemBuyerInfo = Structure.new do
        # Buyer information for custom orders from the Amazon Custom program.
        #
        # **Note**: This attribute is only available for MFN (fulfilled by seller) orders.
        attribute?(:buyer_customized_info, BuyerCustomizedInfoDetail, from: "BuyerCustomizedInfo")

        # A gift message provided by the buyer.
        #
        # **Note**: This attribute is only available for MFN (fulfilled by seller) orders.
        attribute?(:gift_message_text, String, from: "GiftMessageText")

        # The gift wrap level specified by the buyer.
        attribute?(:gift_wrap_level, String, from: "GiftWrapLevel")

        # The gift wrap price of the item.
        attribute?(:gift_wrap_price, Money, from: "GiftWrapPrice")

        # The tax on the gift wrap price.
        attribute?(:gift_wrap_tax, Money, from: "GiftWrapTax")
      end
    end
  end
end
