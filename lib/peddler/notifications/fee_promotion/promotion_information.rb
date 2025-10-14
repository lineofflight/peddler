# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      PromotionInformation = Structure.new do
        # @return [FeeDiscountMonetaryAmount]
        attribute(:fee_discount_monetary_amount, FeeDiscountMonetaryAmount, from: "FeeDiscountMonetaryAmount")

        # @return [String]
        attribute(:fee_discount_type, String, from: "FeeDiscountType")

        # @return [Float]
        attribute(:fee_discount_value, Float, from: "FeeDiscountValue")

        # @return [String]
        attribute(:fee_type, String, from: "FeeType")

        # @return [FeesEstimate]
        attribute(:fees_estimate, FeesEstimate, from: "FeesEstimate")

        # @return [PriceThreshold]
        attribute(:price_threshold, PriceThreshold, from: "PriceThreshold")
      end
    end
  end
end
