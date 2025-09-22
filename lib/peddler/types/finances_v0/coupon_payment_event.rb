# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/finances_v0/fee_component"
require "peddler/types/finances_v0/charge_component"

module Peddler
  module Types
    module FinancesV0
      # An event related to coupon payments.
      CouponPaymentEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] A coupon identifier.
        attribute(:coupon_id, String, from: "CouponId")

        # @return [String] The description provided by the seller when they created the coupon.
        attribute(:seller_coupon_description, String, from: "SellerCouponDescription")

        # @return [Integer] The number of coupon clips or redemptions.
        attribute(:clip_or_redemption_count, Integer, from: "ClipOrRedemptionCount")

        # @return [String] A payment event identifier.
        attribute(:payment_event_id, String, from: "PaymentEventId")

        # @return [FeeComponent]
        attribute(:fee_component, FeeComponent, from: "FeeComponent")

        # @return [ChargeComponent]
        attribute(:charge_component, ChargeComponent, from: "ChargeComponent")

        # @return [Types::Money] The FeeComponent value plus the ChargeComponent value.
        attribute(:total_amount, Types::Money, from: "TotalAmount")
      end
    end
  end
end
