# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/replenishment_2022_11_07/time_interval"

module Peddler
  module Types
    module Replenishment20221107
      # An object which contains offer metrics.
      ListOfferMetricsResponseOffer = Structure.new do
        # @return [Float] The number of active subscriptions present at the end of the period. Applicable to PERFORMANCE
        # timePeriodType.
        attribute?(:active_subscriptions, Float, from: "activeSubscriptions")

        # @return [String] The Amazon Standard Identification Number (ASIN).
        attribute?(:asin, String)

        # @return [Float] The percentage of revenue from ASINs with coupons out of total revenue from all ASINs.
        # Applicable to PERFORMANCE timePeriodType.
        attribute?(:coupons_revenue_penetration, Float, from: "couponsRevenuePenetration")

        # @return [String] The currency code in ISO 4217 format.
        attribute?(:currency_code, String, from: "currencyCode")

        # @return [Float] The revenue that would have been generated had there not been out of stock. Applicable to
        # PERFORMANCE timePeriodType.
        attribute?(:lost_revenue_due_to_oos, Float, from: "lostRevenueDueToOOS")

        # @return [Float] The forecasted shipped subscription units for the next 30 days. Applicable to FORECAST
        # timePeriodType.
        attribute?(:next30_day_shipped_subscription_units, Float, from: "next30DayShippedSubscriptionUnits")

        # @return [Float] The forecasted total subscription revenue for the next 30 days. Applicable to FORECAST
        # timePeriodType.
        attribute?(:next30_day_total_subscriptions_revenue, Float, from: "next30DayTotalSubscriptionsRevenue")

        # @return [Float] The forecasted shipped subscription units for the next 60 days. Applicable to FORECAST
        # timePeriodType.
        attribute?(:next60_day_shipped_subscription_units, Float, from: "next60DayShippedSubscriptionUnits")

        # @return [Float] The forecasted total subscription revenue for the next 60 days. Applicable to FORECAST
        # timePeriodType.
        attribute?(:next60_day_total_subscriptions_revenue, Float, from: "next60DayTotalSubscriptionsRevenue")

        # @return [Float] The forecasted shipped subscription units for the next 90 days. Applicable to FORECAST
        # timePeriodType.
        attribute?(:next90_day_shipped_subscription_units, Float, from: "next90DayShippedSubscriptionUnits")

        # @return [Float] The forecasted total subscription revenue for the next 90 days. Applicable to FORECAST
        # timePeriodType.
        attribute?(:next90_day_total_subscriptions_revenue, Float, from: "next90DayTotalSubscriptionsRevenue")

        # @return [Float] The percentage of items that were not shipped out of the total shipped units over a period of
        # time due to being out of stock. Applicable to PERFORMANCE timePeriodType.
        attribute?(:not_delivered_due_to_oos, Float, from: "notDeliveredDueToOOS")

        # @return [Float] The percentage of total program revenue out of total product revenue. Applicable to
        # PERFORMANCE timePeriodType.
        attribute?(:revenue_penetration, Float, from: "revenuePenetration")

        # @return [Float] The percentage of new subscriptions acquired through coupons. Applicable to PERFORMANCE
        # timePeriodType.
        attribute?(:share_of_coupon_subscriptions, Float, from: "shareOfCouponSubscriptions")

        # @return [Float] The number of units shipped to the subscribers over a period of time. Applicable to
        # PERFORMANCE timePeriodType.
        attribute?(:shipped_subscription_units, Float, from: "shippedSubscriptionUnits")

        # @return [TimeInterval] A time interval used to compute metrics.
        attribute?(:time_interval, TimeInterval, from: "timeInterval")

        # @return [Float] The revenue generated from subscriptions over a period of time. Applicable to PERFORMANCE
        # timePeriodType.
        attribute?(:total_subscriptions_revenue, Float, from: "totalSubscriptionsRevenue")
      end
    end
  end
end
