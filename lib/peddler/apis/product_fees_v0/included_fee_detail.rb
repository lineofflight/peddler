# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductFeesV0
      # The type of fee, fee amount, and other details.
      IncludedFeeDetail = Structure.new do
        # @return [Money] The amount charged for a given fee.
        attribute(:fee_amount, Money, null: false, from: "FeeAmount")

        # @return [String] The type of fee charged to a seller.
        attribute(:fee_type, String, null: false, from: "FeeType")

        # @return [Money] The final fee amount for a given fee.
        attribute(:final_fee, Money, null: false, from: "FinalFee")

        # @return [Money] The promotion amount for a given fee.
        attribute?(:fee_promotion, Money, from: "FeePromotion")

        # @return [Money] The tax amount for a given fee.
        attribute?(:tax_amount, Money, from: "TaxAmount")
      end
    end
  end
end
