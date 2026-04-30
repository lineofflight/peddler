# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Payment execution details for an order.
      PaymentExecution = Structure.new do
        # @return [String] The unique identifier of the payment processor or acquiring bank that authorizes the payment.
        #
        # **Note**: This attribute is only available for orders in the Brazil (BR) marketplace when the `paymentMethod`
        #   is `CreditCard` or `Pix`.
        attribute?(:acquirer_id, String, from: "acquirerId")

        # @return [String] The unique code that confirms the payment authorization.
        #
        # **Note**: This attribute is only available for orders in the Brazil (BR) marketplace when the `paymentMethod`
        #   is `CreditCard` or `Pix`.
        attribute?(:authorization_code, String, from: "authorizationCode")

        # @return [String] The card network or brand used in the payment transaction (for example, Visa or Mastercard).
        #
        # **Note**: This attribute is only available for orders in the Brazil (BR) marketplace when the `paymentMethod`
        #   is `CreditCard`.
        attribute?(:card_brand, String, from: "cardBrand")

        # @return [Money] The monetary value of the payment execution.
        attribute?(:payment_amount, Money, from: "paymentAmount")

        # @return [String] The payment method used for this payment execution (for example, CashOnDelivery,
        #   ConvenienceStore, CreditCard, Invoice, Pix, and so on).
        attribute?(:payment_method, String, from: "paymentMethod")
      end
    end
  end
end
