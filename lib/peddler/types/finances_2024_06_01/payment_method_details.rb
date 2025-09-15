# frozen_string_literal: true

require "peddler/types/finances_2024_06_01/expiry_date"

module Peddler
  module Types
    module Finances20240601
      # The details of a payment method.
      PaymentMethodDetails = Structure.new do
        # @return [String] The name of the account holder who is registered for the payment method.
        attribute(:account_holder_name, String, from: "accountHolderName")

        # @return [String] The payment method identifier.
        attribute(:payment_method_id, String, from: "paymentMethodId")

        # @return [String] The last three or four digits of the payment method.
        attribute(:tail, String)

        # @return [ExpiryDate] The expiration date of the card used for payment.
        attribute(:expiry_date, ExpiryDate, from: "expiryDate")

        # @return [String] The two-letter country code in ISO 3166-1 alpha-2 format. For payment methods in the `card`
        # category, the code is for the country where the card was issued. For payment methods in the `bank account`
        # category, the code is for the country where the account is located.
        attribute(:country_code, String, from: "countryCode")

        # @return [String] The payment method type.
        attribute(:payment_method_type, String, from: "paymentMethodType")

        # @return [String] The payment method assignment type, whether it is assigned as default to the given
        # marketplace or not.
        attribute(:assignment_type, String, from: "assignmentType")
      end
    end
  end
end
