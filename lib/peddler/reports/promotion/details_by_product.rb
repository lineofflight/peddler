# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module Promotion
      # An object that contains details about a product.
      DetailsByProduct = Structure.new do
        # @return [String] The product ASIN.
        attribute(:asin, String)

        # @return [String] The product name.
        attribute(:product_name, String, from: "productName")

        # @return [Float] The total revenue generated at the ASIN level. For sellers, this is equivalent to "sales" in
        # the Seller Central UI.
        attribute(:product_revenue, Float, from: "productRevenue")

        # @return [String] ISO 4217 currency code of productRevenue.
        attribute(:product_revenue_currency_code, String, from: "productRevenueCurrencyCode")

        # @return [Integer] The number of units sold at the promotional price.
        attribute(:product_units_sold, Integer, from: "productUnitsSold")

        # @return [Float] Total funding provided by the vendor at the ASIN level. For vendors only.
        attribute?(:product_amount_spent, Float, from: "productAmountSpent")

        # @return [String] ISO 4217 currency code of productAmountSpent.
        attribute?(:product_amount_spent_currency_code, String, from: "productAmountSpentCurrencyCode")

        # @return [Integer] The number of customer views of the product detail page.
        attribute?(:product_glance_views, Integer, from: "productGlanceViews")
      end
    end
  end
end
