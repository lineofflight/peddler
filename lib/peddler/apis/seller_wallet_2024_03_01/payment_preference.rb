# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # The type of payment preference in which the transfer is being scheduled.
      PaymentPreference = Structure.new do
        # @return [String] The preferred payment type for the scheduled transaction. Can be `PERCENTAGE` or `AMOUNT`.
        attribute(:payment_preference_payment_type, String, null: false, from: "paymentPreferencePaymentType")

        # @return [Float] The value of the payment preference.
        attribute(:value, Float, null: false)
      end
    end
  end
end
