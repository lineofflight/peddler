# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module Promotion
      # An object that contains details about a product.
      DetailsByProduct = Structure.new do
        # The product ASIN.
        attribute(:asin, String, null: false)

        # The product name.
        attribute(:product_name, String, null: false, from: "productName")

        # The total revenue generated at the ASIN level. For sellers, this is equivalent to "sales" in the Seller
        # Central UI.
        attribute(:product_revenue, Float, null: false, from: "productRevenue")

        # ISO 4217 currency code of productRevenue.
        attribute(:product_revenue_currency_code, String, null: false, from: "productRevenueCurrencyCode")

        # The number of units sold at the promotional price.
        attribute(:product_units_sold, Integer, null: false, from: "productUnitsSold")

        # Total funding provided by the vendor at the ASIN level. For vendors only.
        attribute?(:product_amount_spent, Float, from: "productAmountSpent")

        # ISO 4217 currency code of productAmountSpent.
        attribute?(:product_amount_spent_currency_code, String, from: "productAmountSpentCurrencyCode")

        # The number of customer views of the product detail page.
        attribute?(:product_glance_views, Integer, from: "productGlanceViews")
      end
    end
  end
end
