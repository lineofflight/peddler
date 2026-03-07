# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Details of the fee.
      Fee = Structure.new do
        # @return [Money] The actual value of the fee in numeric format.
        attribute(:fee_amount, Money, null: false, from: "feeAmount")

        # @return [String] The unique identifier assigned to the fee.
        attribute(:fee_id, String, null: false, from: "feeId")

        # @return [String] The value of the fee in percentage format.
        attribute(:fee_rate_value, String, null: false, from: "feeRateValue")

        # @return [String] The type of the fee.
        attribute(:fee_type, String, null: false, from: "feeType")
      end
    end
  end
end
