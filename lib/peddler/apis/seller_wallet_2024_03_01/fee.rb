# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellerWallet20240301
      # Details of the fee.
      Fee = Structure.new do
        # The actual value of the fee in numeric format.
        attribute(:fee_amount, Money, null: false, from: "feeAmount")

        # The unique identifier assigned to the fee.
        attribute(:fee_id, String, null: false, from: "feeId")

        # The value of the fee in percentage format.
        attribute(:fee_rate_value, String, null: false, from: "feeRateValue")

        # The type of the fee.
        attribute(:fee_type, String, null: false, from: "feeType")
      end
    end
  end
end
