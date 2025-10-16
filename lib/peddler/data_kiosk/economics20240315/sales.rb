# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The sales data for a given product in the seller's account within a given date range.
      Sales = Structure.new do
        # @return [Amount] The average price of the units sold in the selected time period, calculated by
        # dividing the orderedProductSales by unitsOrdered for the selected time period.
        # This field will be null when unitsOrdered is 0.
        attribute?(:average_selling_price, Amount, from: "averageSellingPrice")

        # @return [Amount] The amount of net product sales, calculated by orderedProductSales - refundedProductSales.
        attribute?(:net_product_sales, Amount, from: "netProductSales")

        # @return [String] The number of net units sold for the selected time period, calculated by unitsOrdered -
        # unitsRefunded.
        attribute?(:net_units_sold, String, from: "netUnitsSold")

        # @return [Amount] The amount of ordered product sales, calculated by multiplying the price of
        # products and the number of units sold for the selected time period.
        attribute?(:ordered_product_sales, Amount, from: "orderedProductSales")

        # @return [Amount] The amount of refunded product sales for the selected time period, it's counted by refund
        # request time.
        attribute?(:refunded_product_sales, Amount, from: "refundedProductSales")

        # @return [String] The number of units ordered for the selected time period. Example: For an
        # order containing 2 copies of book A and 3 copies of book B, the number of
        # orders is 1, the number of order items is 2 (book A and book B), and the
        # number of units is 5 (2 + 3).
        attribute?(:units_ordered, String, from: "unitsOrdered")

        # @return [String] The number of units refunded in the selected time period.
        attribute?(:units_refunded, String, from: "unitsRefunded")
      end
    end
  end
end
