# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductFeesV0
      # The type of fee, fee amount, and other details.
      IncludedFeeDetail = Structure.new do
        # The amount charged for a given fee.
        attribute(:fee_amount, Money, null: false, from: "FeeAmount")

        # The type of fee charged to a seller.
        attribute(:fee_type, String, null: false, from: "FeeType")

        # The final fee amount for a given fee.
        attribute(:final_fee, Money, null: false, from: "FinalFee")

        # The promotion amount for a given fee.
        attribute?(:fee_promotion, Money, from: "FeePromotion")

        # The tax amount for a given fee.
        attribute?(:tax_amount, Money, from: "TaxAmount")
      end
    end
  end
end
