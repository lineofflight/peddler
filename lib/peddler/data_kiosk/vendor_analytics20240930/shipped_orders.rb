# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Shipped orders metric group. A null value for a given metric means that the metric is not available.
      ShippedOrders = Structure.new do
        # @return [Amount] The average selling price of shipped items, excluding sales tax or value-added
        # taxes. This is calculated by dividing revenue by the number of shipped units.
        attribute?(:average_selling_price, Amount, from: "averageSellingPrice")

        # @return [UnitsWithValue] The number of items shipped and the associated gross price the customer paid
        # for them. Shipped Revenue Amount = Gross Price (the price the customer sees in
        # the cart) * Shipped Units.
        attribute?(:shipped_units_with_revenue, UnitsWithValue, from: "shippedUnitsWithRevenue")
      end
    end
  end
end
