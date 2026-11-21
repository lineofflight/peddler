# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShipmentInvoicingV0
      # The shipment item information required by a seller to issue a shipment invoice.
      ShipmentItem = Structure.new do
        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        # The gift wrap price of the item.
        attribute?(:gift_wrap_price, Money, from: "GiftWrapPrice")

        # The selling price of the item multiplied by the quantity ordered. Note that ItemPrice excludes ShippingPrice
        # and GiftWrapPrice.
        attribute?(:item_price, Money, from: "ItemPrice")

        # The Amazon-defined identifier for the order item.
        attribute?(:order_item_id, String, from: "OrderItemId")

        # The total of all promotional discounts in the offer.
        attribute?(:promotion_discount, Money, from: "PromotionDiscount")

        # The number of items ordered.
        attribute?(:quantity_ordered, Float, from: "QuantityOrdered")

        # The seller SKU of the item.
        attribute?(:seller_sku, String, from: "SellerSKU")

        # The list of serial numbers.
        attribute?(:serial_numbers, [String], from: "SerialNumbers")

        # The discount on the shipping price.
        attribute?(:shipping_discount, Money, from: "ShippingDiscount")

        # The shipping price of the item.
        attribute?(:shipping_price, Money, from: "ShippingPrice")

        # The name of the item.
        attribute?(:title, String, from: "Title")
      end
    end
  end
end
