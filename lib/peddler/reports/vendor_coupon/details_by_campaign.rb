# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorCoupon
      # Contains details about a campaign and every included coupon.
      DetailsByCampaign = Structure.new do
        # @return [String] Whether the budget is allocated independently for each coupon or shared among all coupons.
        attribute(:budget_type, String, null: false, from: "budgetType")

        # @return [String] Unique identifier of the campaign.
        attribute(:campaign_id, String, null: false, from: "campaignId")

        # @return [String] Name given to the campaign.
        attribute(:campaign_name, String, null: false, from: "campaignName")

        # @return [Array<CouponDetails>] A list of included coupons and their details.
        attribute(:coupons, [CouponDetails], null: false)

        # @return [Time] Campaign creation date-time in UTC.
        attribute(:creation_date_time, Time, null: false, from: "creationDateTime")

        # @return [:boolean] Whether or not the campaign is a Subscribe and Save offer.
        attribute(:subscribe_and_save, :boolean, null: false, from: "isSubscribeAndSave")

        # @return [Time] The latest date-time the campaign data in this report was updated. May be up to 24 hours before
        #   the current date-time.
        attribute(:last_updated_date_time, Time, null: false, from: "lastUpdatedDateTime")

        # @return [String] The marketplace the campaign is running in.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Integer] Total number of times a coupon in the campaign has been applied on the product page, equal
        #   to the sum of all coupon clips.
        attribute(:total_clips, Integer, null: false, from: "totalClips")

        # @return [Integer] Total number of times a coupon in the campaign has been used for a purchase, equal to the
        #   sum of all coupon redemptions.
        attribute(:total_redemptions, Integer, null: false, from: "totalRedemptions")

        # @return [String] The vendor code associated with the campaign.
        attribute(:vendor_code, String, null: false, from: "vendorCode")

        # @return [String] ISO 4217 currency code of all currency values in the campaign.
        attribute?(:currency_code, String, from: "currencyCode")

        # @return [Float] Total budget allocated to the campaign. Currency value. Only present when budgetType is
        #   SHARED_BUDGET.
        attribute?(:total_budget, Float, from: "totalBudget")

        # @return [Float] The budget remaining for the campaign, equal to totalBudget minus totalBudgetSpent. Currency
        #   value. Only present when budgetType is SHARED_BUDGET.
        attribute?(:total_budget_remaining, Float, from: "totalBudgetRemaining")

        # @return [Float] Total amount spent by the vendor on the campaign, including clip fees and redemption fees,
        #   equal to the sum of all coupon budgetSpent. Currency value. Only present when budgetType is SHARED_BUDGET.
        attribute?(:total_budget_spent, Float, from: "totalBudgetSpent")
      end
    end
  end
end
