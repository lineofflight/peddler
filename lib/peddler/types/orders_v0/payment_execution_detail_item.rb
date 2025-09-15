# frozen_string_literal: true

require "peddler/money"

module Peddler
  module Types
    module OrdersV0
      # Information about a sub-payment method used to pay for a COD order.
      PaymentExecutionDetailItem = Structure.new do
        # @return [Money]
        attribute(:payment, Money, from: "Payment")

        # @return [String] The sub-payment method for an order.
        #
        # **Possible values**:
        # * `COD`: Cash on delivery
        # * `GC`: Gift card
        # * `PointsAccount`: Amazon Points
        # * `Invoice`: Invoice
        # * `CreditCard`: Credit card
        # * `Pix`: Pix
        # * `Other`: Other.
        attribute(:payment_method, String, from: "PaymentMethod")

        # @return [String] The Brazilian Taxpayer Identifier (CNPJ) of the payment processor or acquiring bank that
        # authorizes the payment.
        #
        # **Note**: This attribute is only available for orders in the Brazil (BR) marketplace when the `PaymentMethod`
        # is `CreditCard` or `Pix`.
        attribute(:acquirer_id, String, from: "AcquirerId")

        # @return [String] The card network or brand used in the payment transaction (for example, Visa or Mastercard).
        #
        # **Note**: This attribute is only available for orders in the Brazil (BR) marketplace when the `PaymentMethod`
        # is `CreditCard`.
        attribute(:card_brand, String, from: "CardBrand")

        # @return [String] The unique code that confirms the payment authorization.
        #
        # **Note**: This attribute is only available for orders in the Brazil (BR) marketplace when the `PaymentMethod`
        # is `CreditCard` or `Pix`.
        attribute(:authorization_code, String, from: "AuthorizationCode")
      end
    end
  end
end
