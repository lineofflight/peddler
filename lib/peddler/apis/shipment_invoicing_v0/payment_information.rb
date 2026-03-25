# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShipmentInvoicingV0
      # Information about a payment transaction.
      PaymentInformation = Structure.new do
        # @return [String] The government ID of the acquirer.
        attribute?(:acquirer_id, String, from: "AcquirerId")

        # @return [String] The authorization code of this payment.
        attribute?(:authorization_code, String, from: "AuthorizationCode")

        # @return [String] The credit card brand if the payment method is `CreditCard`.
        attribute?(:card_brand, String, from: "CardBrand")

        # @return [String] The name of the payment method.
        attribute?(:payment_method, String, from: "PaymentMethod")

        # @return [Money] The amount paid in this payment.
        attribute?(:payment_value, Money, from: "PaymentValue")
      end
    end
  end
end
