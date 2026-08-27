# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Performance based fee, usually represented as a percentage of promotion sales with a cap amount.
      VariableFee = Structure.new do
        # @return [Float] Sales Percentage
        attribute(:sales_percentage, Float, null: false, from: "salesPercentage")

        # @return [Money]
        attribute?(:fee_cap_amount, Money, from: "feeCapAmount")
      end
    end
  end
end
