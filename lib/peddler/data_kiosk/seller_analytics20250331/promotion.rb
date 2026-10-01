# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      Promotion = Structure.new do
        # @return [String] Deal identifier.
        attribute?(:deal_id, String, from: "dealId")

        # @return [AmountWithBenchmarking] Price before cart based promotions such as Lightning Deals, POS promotions
        #   and Coupons.
        attribute?(:deal_our_price, AmountWithBenchmarking, from: "dealOurPrice")

        # @return [String] The title of the promotion.
        attribute?(:deal_title, String, from: "dealTitle")

        # @return [String] Promotion ASIN state type refers to the current status or availability of a promoted product
        #   on Amazon.
        attribute?(:promotion_asin_state_type, String, from: "promotionAsinStateType")

        # @return [FloatWithBenchmarking] Promotion conversion rate refers to the percentage of units purchased (net of
        #   cancellations) for a product with an active promotion.
        # It's calculated as the number of units sold, minus any cancelled orders, divided by the number of details page
        #   views for that promotion.
        attribute?(:promotion_conversion_rate, FloatWithBenchmarking, from: "promotionConversionRate")

        # @return [AmountWithBenchmarking] The difference between the price without the promotion (the Amazon landed
        #   price) and the price after the promotion is applied to an item.
        attribute?(:promotion_discount_amt, AmountWithBenchmarking, from: "promotionDiscountAmt")

        # @return [FloatWithBenchmarking] Promotion discount % refers to the percentage discount that's applied to a
        #   product's price as part of a promotional offer.
        # It's calculated as the promotion's discount amount divided by the current price.
        attribute?(:promotion_discount_pct, FloatWithBenchmarking, from: "promotionDiscountPct")

        # @return [String] Promotion end date refers to the date and time, in the local time zone for a store, when a
        #   promotion becomes inactive in that store.
        attribute?(:promotion_end_date, String, from: "promotionEndDate")

        # @return [IntWithBenchmarking] This attribute gives the total count of glance views of the Promotion applicable
        #   ASINS for that reporting period.
        attribute?(:promotion_glance_view_cnt, IntWithBenchmarking, from: "promotionGlanceViewCnt")

        # @return [AmountWithBenchmarking] Promotion price is the final selling price of an item after any promotions
        #   have been applied.
        attribute?(:promotion_ordered_price, AmountWithBenchmarking, from: "promotionOrderedPrice")

        # @return [UnitsWithValueAndBenchmarking] Promotion Ordered Units refers to the total number of units ordered
        #   for products that have an active promotion, with adjustments made for order cancellations and coupon orders.
        #   It is calculated as the count of net ordered units where promotion is active (number of units are set to
        #   zero if the order is canceled and to one for coupon orders).
        #
        # Promotion ordered revenue is the total money earned from selling products that were part of a promotional
        #   offer.
        # It includes the selling prices, shipping fees, taxes, and gift wrap charges, and subtracts the cost of any
        #   returned or refunded items.
        attribute?(:promotion_ordered_units_with_revenue, UnitsWithValueAndBenchmarking, from: "promotionOrderedUnitsWithRevenue")

        # @return [String] Promotion start date refers to the date and time, in the local time zone for a store, when a
        #   promotion becomes active.
        attribute?(:promotion_start_date, String, from: "promotionStartDate")

        # @return [String] Promotion status indicates if a promotion is approved, pending or rejected.
        attribute?(:promotion_status, String, from: "promotionStatus")

        # @return [String] Identifies the type of the promotion for ASIN level data. Example values are Best Deal, Deal
        #   of the Day, Lightning Deal, Sales Discount.
        attribute?(:promotion_type, String, from: "promotionType")
      end
    end
  end
end
