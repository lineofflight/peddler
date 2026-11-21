# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShipmentInvoicingV0
      # Information about a payment transaction.
      PaymentInformation = Structure.new do
        # The government ID of the acquirer.
        attribute?(:acquirer_id, String, from: "AcquirerId")

        # The authorization code of this payment.
        attribute?(:authorization_code, String, from: "AuthorizationCode")

        # The credit card brand if the payment method is `CreditCard`.
        attribute?(:card_brand, String, from: "CardBrand")

        # The name of the payment method. Known values: `CreditCard`, `DebitCard`, `Pix`, `BankSlip`, `GiftCard`,
        # `Other`.
        attribute?(:payment_method, String, from: "PaymentMethod")

        # The amount paid in this payment.
        attribute?(:payment_value, Money, from: "PaymentValue")
      end
    end
  end
end
