# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellingPartnerRepeatPurchase
      # Contains repeat purchase analytics data for each ASIN in the selling partner's catalog
      DataByASIN = Structure.new do
        # Amazon Standard Identification Number.
        attribute(:asin, String, null: false)

        # The end date of the data contained within the object.
        attribute(:end_date, Date, null: false, from: "endDate")

        # The number of orders. An order may include multiple quantities of a product and differs from ordered units.
        attribute(:orders, Integer, null: false)

        # Fraction of unique customers that are repeat customers.
        attribute(:repeat_customers_pct_total, Float, null: false, from: "repeatCustomersPctTotal")

        # Ordered revenue from repeat customers. Returns are not reflected.
        attribute(:repeat_purchase_revenue, Money, null: false, from: "repeatPurchaseRevenue")

        # Fraction of repeatPurchaseRevenue versus total revenue.
        attribute(:repeat_purchase_revenue_pct_total, Float, null: false, from: "repeatPurchaseRevenuePctTotal")

        # The start date of the data contained within the object. If the request spans multiple reportPeriods, byAsin
        # data will be shared for each of these reportPeriods.
        attribute(:start_date, Date, null: false, from: "startDate")

        # Number of unique customers who placed an order containing the asin.
        attribute(:unique_customers, Integer, null: false, from: "uniqueCustomers")
      end
    end
  end
end
