# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Replenishment20221107
      # An object which contains metric data for a selling partner.
      GetSellingPartnerMetricsResponseMetric = Structure.new do
        # @return [Float] The number of active subscriptions present at the end of the period. Applicable to
        #   `PERFORMANCE` `timePeriodType`.
        attribute?(:active_subscriptions, Float, from: "activeSubscriptions")

        # @return [Float] The percentage of revenue from ASINs with coupons out of total revenue from all ASINs.
        #   Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:coupons_revenue_penetration, Float, from: "couponsRevenuePenetration")

        # @return [String] The currency code in ISO 4217 format.
        attribute?(:currency_code, String, from: "currencyCode")

        # @return [Float] Revenue from one-time purchase orders placed by customers who have maintained an active
        #   subscription with your catalog for more than 12 months.
        attribute?(:established_subscriber_life_time_value_from_otp, Float, from: "establishedSubscriberLifeTimeValueFromOTP")

        # @return [Float] Revenue from Subscribe & Save orders placed by customers who have maintained an active
        #   subscription with your catalog for more than 12 months.
        attribute?(:established_subscriber_life_time_value_from_sns, Float, from: "establishedSubscriberLifeTimeValueFromSNS")

        # @return [Float] Revenue from one-time purchase orders placed by customers who started their first subscription
        #   with your catalog within the past 12 months.
        attribute?(:growing_subscriber_life_time_value_from_otp, Float, from: "growingSubscriberLifeTimeValueFromOTP")

        # @return [Float] Revenue from Subscribe & Save orders placed by customers who started their first subscription
        #   with your catalog within the past 12 months.
        attribute?(:growing_subscriber_life_time_value_from_sns, Float, from: "growingSubscriberLifeTimeValueFromSNS")

        # @return [Float] The revenue that would have been generated had there not been out of stock. Applicable to
        #   `PERFORMANCE` `timePeriodType`.
        attribute?(:lost_revenue_due_to_oos, Float, from: "lostRevenueDueToOOS")

        # @return [Float] Revenue from one-time purchase orders placed by customers who previously had subscriptions but
        #   currently have none active in your catalog.
        attribute?(:lost_subscriber_life_time_value_from_otp, Float, from: "lostSubscriberLifeTimeValueFromOTP")

        # @return [Float] Revenue from Subscribe & Save orders placed by customers who previously had subscriptions but
        #   currently have none active in your catalog.
        attribute?(:lost_subscriber_life_time_value_from_sns, Float, from: "lostSubscriberLifeTimeValueFromSNS")

        # @return [Float] The average reorders per non-subscriber of the program over a period of past 12 months.
        #   Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:non_subscriber_average_reorders, Float, from: "nonSubscriberAverageReorders")

        # @return [Float] The average revenue per non-subscriber of the program over a period of past 12 months for
        #   sellers and 6 months for vendors. Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:non_subscriber_average_revenue, Float, from: "nonSubscriberAverageRevenue")

        # @return [Float] Total revenue from customers who have made purchases from your catalog but have never
        #   subscribed to any products
        attribute?(:non_subscriber_life_time_value_from_otp, Float, from: "nonSubscriberLifeTimeValueFromOTP")

        # @return [Float] The percentage of items that were not shipped out of the total shipped units over a period of
        #   time due to being out of stock. Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:not_delivered_due_to_oos, Float, from: "notDeliveredDueToOOS")

        # @return [Float] The subscription revenue generated from active subscriptions with one delivery over the past
        #   12 months. Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:revenue_from_active_subscriptions_with_single_delivery, Float, from: "revenueFromActiveSubscriptionsWithSingleDelivery")

        # @return [Float] The subscription revenue generated from subscriptions which are cancelled after one delivery
        #   over the past 12 months. Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:revenue_from_cancelled_subscriptions_after_single_delivery, Float, from: "revenueFromCancelledSubscriptionsAfterSingleDelivery")

        # @return [Float] The subscription revenue generated from subscriptions with over two deliveries over the past
        #   12 months. Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:revenue_from_subscriptions_with_multiple_deliveries, Float, from: "revenueFromSubscriptionsWithMultipleDeliveries")

        # @return [Float] The percentage of subscription revenue generated by offers with 0% seller-funded discount over
        #   the last 12 months. Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:revenue_penetration_for0_percent_seller_funding, Float, from: "revenuePenetrationFor0PercentSellerFunding")

        # @return [Float] [Applicable only for Sellers] The percentage of subscription revenue generated by offers with
        #   10% seller-funded discount over the last 12 months. Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:revenue_penetration_for10_percent_seller_funding, Float, from: "revenuePenetrationFor10PercentSellerFunding")

        # @return [Float] [Applicable only for Sellers] The percentage of subscription revenue generated by offers with
        #   5% seller-funded discount over the last 12 months. Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:revenue_penetration_for5_percent_seller_funding, Float, from: "revenuePenetrationFor5PercentSellerFunding")

        # @return [Float] [Applicable only for vendors] The percentage of subscription revenue generated by offers with
        #   5% or above seller-funded discount over the last 12 months. Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:revenue_penetration_for5_plus_percent_seller_funding, Float, from: "revenuePenetrationFor5PlusPercentSellerFunding")

        # @return [Float] The percentage of new subscriptions acquired through coupons. Applicable to `PERFORMANCE`
        #   `timePeriodType`.
        attribute?(:share_of_coupon_subscriptions, Float, from: "shareOfCouponSubscriptions")

        # @return [Float] The number of units shipped to the subscribers over a period of time. Applicable for both the
        #   `PERFORMANCE` and `FORECAST` `timePeriodType`.
        attribute?(:shipped_subscription_units, Float, from: "shippedSubscriptionUnits")

        # @return [Float] Percentage of subscriptions created by offers with 0% seller-funded discount out of the total
        #   number of new orders placed over the past 12 months
        attribute?(:signup_conversion_for0_percent_seller_funding, Float, from: "signupConversionFor0PercentSellerFunding")

        # @return [Float] [Applicable only for Sellers] Percentage of subscriptions created by offers with 10%
        #   seller-funded discount out of the total number of new orders placed over the past 12 months
        attribute?(:signup_conversion_for10_percent_seller_funding, Float, from: "signupConversionFor10PercentSellerFunding")

        # @return [Float] [Applicable only for Sellers] Percentage of subscriptions created by offers with 5%
        #   seller-funded discount out of the total number of new orders placed over the past 12 months
        attribute?(:signup_conversion_for5_percent_seller_funding, Float, from: "signupConversionFor5PercentSellerFunding")

        # @return [Float] [Applicable only for Vendors] Percentage of subscriptions created by offers with 5% or above
        #   seller-funded discount out of the total number of new orders placed over the past 12 months
        attribute?(:signup_conversion_for5_plus_percent_seller_funding, Float, from: "signupConversionFor5PlusPercentSellerFunding")

        # @return [Float] The average reorders per subscriber of the program over a period of 12 months. Applicable to
        #   `PERFORMANCE` `timePeriodType`.
        attribute?(:subscriber_average_reorders, Float, from: "subscriberAverageReorders")

        # @return [Float] The average revenue per subscriber of the program over a period of past 12 months for sellers
        #   and 6 months for vendors. Applicable to `PERFORMANCE` `timePeriodType`.
        attribute?(:subscriber_average_revenue, Float, from: "subscriberAverageRevenue")

        # @return [Float] The percentage of subscriptions retained after 30 days of subscription creation. Applicable to
        #   `PERFORMANCE` `timePeriodType`.
        attribute?(:subscriber_retention_for30_days, Float, from: "subscriberRetentionFor30Days")

        # @return [Float] The percentage of subscriptions retained after 90 days of subscription creation. Applicable to
        #   `PERFORMANCE` `timePeriodType`.
        attribute?(:subscriber_retention_for90_days, Float, from: "subscriberRetentionFor90Days")

        # @return [TimeInterval] A time interval used to compute metrics.
        attribute?(:time_interval, TimeInterval, from: "timeInterval")

        # @return [Float] The revenue generated from subscriptions over a period of time. Applicable for both the
        #   `PERFORMANCE` and `FORECAST` `timePeriodType`.
        attribute?(:total_subscriptions_revenue, Float, from: "totalSubscriptionsRevenue")
      end
    end
  end
end
