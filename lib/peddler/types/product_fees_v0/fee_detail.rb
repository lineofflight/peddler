# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "peddler/types/product_fees_v0/included_fee_detail"

module Peddler
  module Types
    module ProductFeesV0
      # The type of fee, fee amount, and other details.
      FeeDetail = Structure.new do
        # @return [Money] The amount charged for a given fee.
        attribute(:fee_amount, Money, from: "FeeAmount")

        # @return [String] The type of fee charged to a seller.
        attribute(:fee_type, String, from: "FeeType")

        # @return [Money] The final fee amount for a given fee.
        attribute(:final_fee, Money, from: "FinalFee")

        # @return [Money] The promotion amount for a given fee.
        attribute?(:fee_promotion, Money, from: "FeePromotion")

        # @return [Array<IncludedFeeDetail>]
        attribute?(:included_fee_detail_list, [IncludedFeeDetail], from: "IncludedFeeDetailList")

        # @return [Money] The tax amount for a given fee.
        attribute?(:tax_amount, Money, from: "TaxAmount")
      end
    end
  end
end
