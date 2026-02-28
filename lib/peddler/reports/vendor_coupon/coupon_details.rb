# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorCoupon
      # Contains details about a coupon.
      CouponDetails = Structure.new do
        # @return [Array<AsinDetails>] Discount details of the products associated with the coupon.
        attribute(:asins, [ASINDetails], null: false)

        # @return [Float] Percentage of the allocated budget that has been spent, equal to the budgetSpent divided by
        #   budget or campaign totalBudget as appropriate.
        attribute(:budget_percentage_used, Float, null: false, from: "budgetPercentageUsed")

        # @return [Float] Total amount spent by the vendor on the coupon, including clip fees and redemption fees.
        #   Currency value. Represents a gross value, including purchases that were returned or cancelled.
        attribute(:budget_spent, Float, null: false, from: "budgetSpent")

        # @return [Integer] Number of times the coupon has been applied on the product page.
        attribute(:clips, Integer, null: false)

        # @return [String] Unique identifier of the coupon.
        attribute(:coupon_id, String, null: false, from: "couponId")

        # @return [String] The customer segment that the coupon is available to.
        attribute(:customer_segment, String, null: false, from: "customerSegment")

        # @return [Time] Coupon end date-time in UTC.
        attribute(:end_date_time, Time, null: false, from: "endDateTime")

        # @return [:boolean] Whether or not the coupon can only be redeemed once per customer account.
        attribute(:once_per_customer, :boolean, null: false, from: "isOncePerCustomer")

        # @return [Integer] Number of times the coupon has been used for a purchase. Represents a gross value, including
        #   purchases that were returned or cancelled.
        attribute(:redemptions, Integer, null: false)

        # @return [Time] Coupon start date-time in UTC.
        attribute(:start_date_time, Time, null: false, from: "startDateTime")

        # @return [Float] Total amount saved by customers redeeming the coupon. Currency value. Represents a gross
        #   value, including purchases that were returned or cancelled.
        attribute(:total_discount, Float, null: false, from: "totalDiscount")

        # @return [Float] Budget allocated to the coupon. Currency value. Only present when campaign budgetType is
        #   PER_INDIVIDUAL_COUPON.
        attribute?(:budget, Float)

        # @return [Float] Budget remaining for the coupon, equal to budget minus budgetSpent. Currency value. Only
        #   present when campaign budgetType is PER_INDIVIDUAL_COUPON. Represents a gross value, including purchases
        #   that were returned or cancelled.
        attribute?(:budget_remaining, Float, from: "budgetRemaining")

        # @return [String] The name given to the coupon.
        attribute?(:name, String)

        # @return [String] Message displayed with the coupon on the product page.
        attribute?(:website_message, String, from: "websiteMessage")
      end
    end
  end
end
