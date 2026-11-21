# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellerSalesAndTraffic
      # Object describing sales metrics for ASINs in the seller's account aggregated by date.
      SalesByDate = Structure.new do
        # The average ordered product sales, calculated by dividing orderedProductSales by totalOrderItems for the
        # selected time period.
        attribute(:average_sales_per_order_item, Money, null: false, from: "averageSalesPerOrderItem")

        # The average price of the units sold in the selected time period, calculated by dividing the
        # orderedProductSales by unitsOrdered for the selected time period.
        attribute(:average_selling_price, Money, null: false, from: "averageSellingPrice")

        # The average number of units in each order item for the selected time period.
        attribute(:average_units_per_order_item, Float, null: false, from: "averageUnitsPerOrderItem")

        # Monetary amount of filed A-to-z guarantee claims.
        attribute(:claims_amount, Money, null: false, from: "claimsAmount")

        # The number of A-to-z guarantee claims granted.
        attribute(:claims_granted, Integer, null: false, from: "claimsGranted")

        # The amount of ordered product sales, calculated by multiplying the price of products and the number of units
        # sold for the selected time period.
        attribute(:ordered_product_sales, Money, null: false, from: "orderedProductSales")

        # The number of orders shipped in the selected time period.
        attribute(:orders_shipped, Integer, null: false, from: "ordersShipped")

        # The percentage conversion metric indicating how many orders were refunded by the seller, calculated by
        # dividing unitsOrdered by unitsRefunded in the selected time period.
        attribute(:refund_rate, Float, null: false, from: "refundRate")

        # The amount of ordered product sales shipped for the selected time period.
        attribute(:shipped_product_sales, Money, null: false, from: "shippedProductSales")

        # The number of items that were ordered for the selected time period. For clarification on the difference
        # between orders, order items, and units take the following order as an example: An order containing 2 copies of
        # book A and 3 copies of book B; The number of orders is 1, the number of order items is 2 (book A and book B),
        # and the number of units is 5 (2 + 3).
        attribute(:total_order_items, Integer, null: false, from: "totalOrderItems")

        # The number of units ordered for the selected time period. For clarification on the difference between orders,
        # order items, and units take the following order as an example: An order containing 2 copies of book A and 3
        # copies of book B; The number of orders is 1, the number of order items is 2 (book A and book B), and the
        # number of units is 5 (2 + 3).
        attribute(:units_ordered, Integer, null: false, from: "unitsOrdered")

        # The number of units refunded in the selected time period.
        attribute(:units_refunded, Integer, null: false, from: "unitsRefunded")

        # The number of units shipped in the selected time period.
        attribute(:units_shipped, Integer, null: false, from: "unitsShipped")

        # The average ordered product sales to Amazon Business customers, calculated by dividing orderedProductSalesB2B
        # by totalOrderItemsB2B for the selected time period. Note: This field is only populated when the seller is a
        # B2B seller.
        attribute?(:average_sales_per_order_item_b2b, Money, from: "averageSalesPerOrderItemB2B")

        # The average price of the units sold to Amazon Business customers, calculated by dividing the
        # orderedProductSalesB2B by unitsOrderedB2B for the selected time period. Note: This field is only populated
        # when the seller is a B2B seller.
        attribute?(:average_selling_price_b2b, Money, from: "averageSellingPriceB2B")

        # The average number of units in each order item ordered by Amazon Business customers for the selected time
        # period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:average_units_per_order_item_b2b, Float, from: "averageUnitsPerOrderItemB2B")

        # The amount of ordered product sales to Amazon Business customers, calculated by multiplying the price of
        # products and the number of units sold for the selected time period. Note: This field is only populated when
        # the seller is a B2B seller.
        attribute?(:ordered_product_sales_b2b, Money, from: "orderedProductSalesB2B")

        # The number of items that were ordered by Amazon Business customers for the selected time period. For
        # clarification on the difference between orders, order items, and units take the following order as an example:
        # An order containing 2 copies of book A and 3 copies of book B; The number of orders is 1, the number of order
        # items is 2 (book A and book B), and the number of units is 5 (2 + 3). Note: This field is only populated when
        # the seller is a B2B seller.
        attribute?(:total_order_items_b2b, Integer, from: "totalOrderItemsB2B")

        # The number of units ordered by Amazon Business customers for the selected time period. For clarification on
        # the difference between orders, order items, and units take the following order as an example: An order
        # containing 2 copies of book A and 3 copies of book B; The number of orders is 1, the number of order items is
        # 2 (book A and book B), and the number of units is 5 (2 + 3). Note: This field is only populated when the
        # seller is a B2B seller.
        attribute?(:units_ordered_b2b, Integer, from: "unitsOrderedB2B")
      end
    end
  end
end
