# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      IncludedFee = Structure.new do
        # @return [FeeAmount]
        attribute(:fee_amount, FeeAmount, null: false, from: "FeeAmount")

        # @return [FeePromotion]
        attribute(:fee_promotion, FeePromotion, null: false, from: "FeePromotion")

        # @return [String]
        attribute(:fee_type, String, null: false, from: "FeeType")

        # @return [FinalFee]
        attribute(:final_fee, FinalFee, null: false, from: "FinalFee")

        # @return [TaxAmount]
        attribute(:tax_amount, TaxAmount, null: false, from: "TaxAmount")
      end
    end
  end
end
