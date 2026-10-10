# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      IncludedFee = Structure.new do
        attribute(:fee_amount, FeeAmount, null: false, from: "FeeAmount")

        attribute(:fee_promotion, FeePromotion, null: false, from: "FeePromotion")

        attribute(:fee_type, String, null: false, from: "FeeType")

        attribute(:final_fee, FinalFee, null: false, from: "FinalFee")

        attribute(:tax_amount, TaxAmount, null: false, from: "TaxAmount")
      end
    end
  end
end
