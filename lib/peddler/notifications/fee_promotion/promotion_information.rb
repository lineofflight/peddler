# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      PromotionInformation = Structure.new do
        attribute(:fee_discount_type, String, null: false, from: "FeeDiscountType")

        attribute(:fee_type, String, null: false, from: "FeeType")

        attribute?(:fee_discount_monetary_amount, FeeDiscountMonetaryAmount, from: "FeeDiscountMonetaryAmount")

        attribute?(:fee_discount_value, Float, from: "FeeDiscountValue")

        attribute?(:fees_estimate, FeesEstimate, from: "FeesEstimate")

        attribute?(:price_threshold, PriceThreshold, from: "PriceThreshold")
      end
    end
  end
end
