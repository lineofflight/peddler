# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/product_fees_v0/money_type"

module Peddler
  module Types
    module ProductFeesV0
      # The type of fee, fee amount, and other details.
      IncludedFeeDetail = Structure.new do
        # @return [String] The type of fee charged to a seller.
        attribute(:fee_type, String, from: "FeeType")

        # @return [Types::Money] The amount charged for a given fee.
        attribute(:fee_amount, Types::Money, from: "FeeAmount")

        # @return [Types::Money] The promotion amount for a given fee.
        attribute(:fee_promotion, Types::Money, from: "FeePromotion")

        # @return [Types::Money] The tax amount for a given fee.
        attribute(:tax_amount, Types::Money, from: "TaxAmount")

        # @return [Types::Money] The final fee amount for a given fee.
        attribute(:final_fee, Types::Money, from: "FinalFee")
      end
    end
  end
end
