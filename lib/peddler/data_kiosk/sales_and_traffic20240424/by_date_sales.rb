# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SalesAndTraffic20240424
      # The sales data for the seller's account aggregated by date.
      ByDateSales = Structure.new do
        # @return [Amount] The average ordered product sales, calculated by dividing orderedProductSales
        # by totalOrderItems for the selected time period.
        attribute?(:average_sales_per_order_item, Amount, from: "averageSalesPerOrderItem")

        # @return [Amount] The average ordered product sales to Amazon Business customers, calculated by
        # dividing orderedProductSalesB2B by totalOrderItemsB2B for the selected time
        # period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:average_sales_per_order_item_b2b, Amount, from: "averageSalesPerOrderItemB2B")

        # @return [Amount] The average price of the units sold in the selected time period, calculated by
        # dividing the orderedProductSales by unitsOrdered for the selected time period.
        attribute?(:average_selling_price, Amount, from: "averageSellingPrice")

        # @return [Amount] The average price of the units sold to Amazon Business customers, calculated
        # by dividing the orderedProductSalesB2B by unitsOrderedB2B for the selected
        # time period. Note: This field is only populated when the seller is a B2B seller.
        attribute?(:average_selling_price_b2b, Amount, from: "averageSellingPriceB2B")

        # @return [Float] The average number of units in each order item for the selected time period.
        attribute?(:average_units_per_order_item, Float, from: "averageUnitsPerOrderItem")

        # @return [Float] The average number of units in each order item ordered by Amazon Business
        # customers for the selected time period. Note: This field is only populated
        # when the seller is a B2B seller.
        attribute?(:average_units_per_order_item_b2b, Float, from: "averageUnitsPerOrderItemB2B")

        # @return [Amount] Monetary amount of filed A-to-z guarantee claims.
        attribute?(:claims_amount, Amount, from: "claimsAmount")

        # @return [String] The number of A-to-z guarantee claims granted.
        attribute?(:claims_granted, String, from: "claimsGranted")

        # @return [Amount] The amount of ordered product sales, calculated by multiplying the price of
        # products and the number of units sold for the selected time period.
        attribute?(:ordered_product_sales, Amount, from: "orderedProductSales")

        # @return [Amount] The amount of ordered product sales to Amazon Business customers, calculated
        # by multiplying the price of products and the number of units sold for the
        # selected time period.
        attribute?(:ordered_product_sales_b2b, Amount, from: "orderedProductSalesB2B")

        # @return [String] The number of orders shipped in the selected time period.
        attribute?(:orders_shipped, String, from: "ordersShipped")

        # @return [Float] The percentage conversion metric indicating how many orders were refunded by
        # the seller, calculated by dividing unitsOrdered by unitsRefunded in the
        # selected time period.
        attribute?(:refund_rate, Float, from: "refundRate")

        # @return [Amount] The amount of ordered product sales shipped for the selected time period.
        attribute?(:shipped_product_sales, Amount, from: "shippedProductSales")

        # @return [String] The number of items that were ordered for the selected time period. Example:
        # For an order containing 2 copies of book A and 3 copies of book B, the number
        # of orders is 1, the number of order items is 2 (book A and book B), and the
        # number of units is 5 (2 + 3).
        attribute?(:total_order_items, String, from: "totalOrderItems")

        # @return [String] The number of items that were ordered by Amazon Business customers for the
        # selected time period. Example: For an order containing 2 copies of book A and
        # 3 copies of book B, the number of orders is 1, the number of order items is 2
        # (book A and book B), and the number of units is 5 (2 + 3).
        attribute?(:total_order_items_b2b, String, from: "totalOrderItemsB2B")

        # @return [String] The number of units ordered for the selected time period. Example: For an
        # order containing 2 copies of book A and 3 copies of book B, the number of
        # orders is 1, the number of order items is 2 (book A and book B), and the
        # number of units is 5 (2 + 3).
        attribute?(:units_ordered, String, from: "unitsOrdered")

        # @return [String] The number of units ordered by Amazon Business customers for the selected time
        # period. Example: For an order containing 2 copies of book A and 3 copies of
        # book B, the number of orders is 1, the number of order items is 2 (book A and
        # book B), and the number of units is 5 (2 + 3).
        attribute?(:units_ordered_b2b, String, from: "unitsOrderedB2B")

        # @return [String] The number of units refunded in the selected time period.
        attribute?(:units_refunded, String, from: "unitsRefunded")

        # @return [String] The number of units shipped in the selected time period.
        attribute?(:units_shipped, String, from: "unitsShipped")
      end
    end
  end
end
