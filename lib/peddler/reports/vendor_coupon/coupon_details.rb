# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorCoupon
      # Contains details about a coupon.
      CouponDetails = Structure.new do
        # Discount details of the products associated with the coupon.
        attribute(:asins, [ASINDetails], null: false)

        # Percentage of the allocated budget that has been spent, equal to the budgetSpent divided by budget or campaign
        # totalBudget as appropriate.
        attribute(:budget_percentage_used, Float, null: false, from: "budgetPercentageUsed")

        # Total amount spent by the vendor on the coupon, including clip fees and redemption fees. Currency value.
        # Represents a gross value, including purchases that were returned or cancelled.
        attribute(:budget_spent, Float, null: false, from: "budgetSpent")

        # Number of times the coupon has been applied on the product page.
        attribute(:clips, Integer, null: false)

        # Unique identifier of the coupon.
        attribute(:coupon_id, String, null: false, from: "couponId")

        # The customer segment that the coupon is available to.
        attribute(:customer_segment, String, null: false, from: "customerSegment")

        # Coupon end date-time in UTC.
        attribute(:end_date_time, Time, null: false, from: "endDateTime")

        # Whether or not the coupon can only be redeemed once per customer account.
        attribute(:once_per_customer, :boolean, null: false, from: "isOncePerCustomer")

        # Number of times the coupon has been used for a purchase. Represents a gross value, including purchases that
        # were returned or cancelled.
        attribute(:redemptions, Integer, null: false)

        # Coupon start date-time in UTC.
        attribute(:start_date_time, Time, null: false, from: "startDateTime")

        # Total amount saved by customers redeeming the coupon. Currency value. Represents a gross value, including
        # purchases that were returned or cancelled.
        attribute(:total_discount, Float, null: false, from: "totalDiscount")

        # Budget allocated to the coupon. Currency value. Only present when campaign budgetType is
        # PER_INDIVIDUAL_COUPON.
        attribute?(:budget, Float)

        # Budget remaining for the coupon, equal to budget minus budgetSpent. Currency value. Only present when campaign
        # budgetType is PER_INDIVIDUAL_COUPON. Represents a gross value, including purchases that were returned or
        # cancelled.
        attribute?(:budget_remaining, Float, from: "budgetRemaining")

        # The name given to the coupon.
        attribute?(:name, String)

        # Unique identifier to cross-reference promotions with the Selling Partner Promotions API.
        attribute?(:promotions_api_mapping_id, String, from: "promotionsApiMappingId")

        # Message displayed with the coupon on the product page.
        attribute?(:website_message, String, from: "websiteMessage")
      end
    end
  end
end
