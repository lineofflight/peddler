# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      FeeDetail = Structure.new do
        attribute(:fee_amount, FeeAmount, null: false, from: "FeeAmount")

        attribute(:fee_type, String, null: false, from: "FeeType")

        attribute(:final_fee, FinalFee, null: false, from: "FinalFee")

        attribute?(:fee_promotion, FeePromotion, from: "FeePromotion")

        attribute?(:included_fees, Array, from: "IncludedFees")

        attribute?(:tax_amount, TaxAmount, from: "TaxAmount")
      end
    end
  end
end
