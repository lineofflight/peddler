# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Payment preference type in which transfer is being scheduled
      PaymentPreference = Structure.new do
        # @return [String] Specifies the preferred payment type for the scheduled transaction eg:PERCENTAGE of certain
        #   total amount in account
        attribute(:payment_preference_payment_type, String, from: "paymentPreferencePaymentType")

        # @return [Float] The value of the payment preference.
        attribute(:value, Float)
      end
    end
  end
end
