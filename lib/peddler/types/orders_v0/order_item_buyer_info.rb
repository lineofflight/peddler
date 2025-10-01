# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "peddler/types/orders_v0/buyer_customized_info_detail"

module Peddler
  module Types
    module OrdersV0
      # A single order item's buyer information.
      OrderItemBuyerInfo = Structure.new do
        # @return [String] An Amazon-defined order item identifier.
        attribute(:order_item_id, String, from: "OrderItemId")

        # @return [BuyerCustomizedInfoDetail] Buyer information for custom orders from the Amazon Custom program.
        #
        # **Note**: This attribute is only available for MFN (fulfilled by seller) orders.
        attribute?(:buyer_customized_info, BuyerCustomizedInfoDetail, from: "BuyerCustomizedInfo")

        # @return [String] A gift message provided by the buyer.
        #
        # **Note**: This attribute is only available for MFN (fulfilled by seller) orders.
        attribute?(:gift_message_text, String, from: "GiftMessageText")

        # @return [String] The gift wrap level specified by the buyer.
        attribute?(:gift_wrap_level, String, from: "GiftWrapLevel")

        # @return [Money] The gift wrap price of the item.
        attribute?(:gift_wrap_price, Money, from: "GiftWrapPrice")

        # @return [Money] The tax on the gift wrap price.
        attribute?(:gift_wrap_tax, Money, from: "GiftWrapTax")
      end
    end
  end
end
