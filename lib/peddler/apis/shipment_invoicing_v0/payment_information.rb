# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShipmentInvoicingV0
      # Payment transaction information
      PaymentInformation = Structure.new do
        # @return [String] Government ID of acquirer
        attribute?(:acquirer_id, String, from: "AcquirerId")

        # @return [String] Authorization code for this payment
        attribute?(:authorization_code, String, from: "AuthorizationCode")

        # @return [String] Credit card brand (if payment method is CreditCard)
        attribute?(:card_brand, String, from: "CardBrand")

        # @return [String] Payment method name
        attribute?(:payment_method, String, from: "PaymentMethod")

        # @return [Money] Amount paid in this payment
        attribute?(:payment_value, Money, from: "PaymentValue")
      end
    end
  end
end
