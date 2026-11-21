# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # An event related to coupon payments.
      CouponPaymentEvent = Structure.new do
        attribute?(:charge_component, ChargeComponent, from: "ChargeComponent")

        # The number of coupon clips or redemptions.
        attribute?(:clip_or_redemption_count, Integer, from: "ClipOrRedemptionCount")

        # A coupon identifier.
        attribute?(:coupon_id, String, from: "CouponId")

        attribute?(:fee_component, FeeComponent, from: "FeeComponent")

        # A payment event identifier.
        attribute?(:payment_event_id, String, from: "PaymentEventId")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # The description provided by the seller when they created the coupon.
        attribute?(:seller_coupon_description, String, from: "SellerCouponDescription")

        # The `FeeComponent` value plus the `ChargeComponent` value.
        attribute?(:total_amount, Money, from: "TotalAmount")
      end
    end
  end
end
