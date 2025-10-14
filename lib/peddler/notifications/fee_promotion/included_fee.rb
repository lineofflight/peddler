# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      IncludedFee = Structure.new do
        # @return [FeeAmount]
        attribute(:fee_amount, FeeAmount, from: "FeeAmount")

        # @return [FeePromotion]
        attribute(:fee_promotion, FeePromotion, from: "FeePromotion")

        # @return [String]
        attribute(:fee_type, String, from: "FeeType")

        # @return [FinalFee]
        attribute(:final_fee, FinalFee, from: "FinalFee")

        # @return [TaxAmount]
        attribute(:tax_amount, TaxAmount, from: "TaxAmount")
      end
    end
  end
end
