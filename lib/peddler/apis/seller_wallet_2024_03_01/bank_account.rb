# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellerWallet20240301
      # Details of an Amazon Seller Wallet bank account. This account is used to hold the money that a Seller Wallet
      # customer earns by selling items.
      BankAccount = Structure.new do
        # The two-digit country code in ISO 3166 format.
        attribute(:account_country_code, String, null: false, from: "accountCountryCode")

        # Bank account currency code in ISO 4217 format.
        attribute(:account_currency, String, null: false, from: "accountCurrency")

        # The last 3 digit of the bank account number. This value is three consecutive zeros for Amazon Seller Wallet
        # accounts.
        attribute(:bank_account_number_tail, String, null: false, from: "bankAccountNumberTail")

        # Type of ownership of the bank account. This value is `SELF` for Amazon Seller Wallet accounts.
        attribute(:bank_account_ownership_type, String, null: false, from: "bankAccountOwnershipType")

        # The bank account holder's name (expected to be an Amazon customer). There is a 50 character limit.
        attribute?(:account_holder_name, String, from: "accountHolderName")

        # The unique bank account identifier provided by Amazon. To initiate a `SELF` transaction with Seller Wallet,
        # you must choose `BANK_ACCOUNT` as the payment method type in the
        # [getPaymentMethod](https://developer-docs.amazon.com/sp-api/reference/getpaymentmethods) request. Your Amazon
        # Seller Wallet bank account identifier should match the `paymentMethodId` in the response. This field is
        # required.
        attribute?(:account_id, String, from: "accountId")

        # The compliance status of the bank account holder.
        attribute?(:bank_account_holder_status, String, from: "bankAccountHolderStatus")

        # The format in which the bank account number is provided for `THIRD_PARTY` transaction requests.
        attribute?(:bank_account_number_format, String, from: "bankAccountNumberFormat")

        # The name of the bank. This value is Amazon Seller Wallet for Amazon Seller Wallet accounts.
        attribute?(:bank_name, String, from: "bankName")

        # The bank number format or routing number type for `THIRD_PARTY` transaction requests.
        attribute?(:bank_number_format, String, from: "bankNumberFormat")

        # Routing number for automated clearing house transfers for `THIRD_PARTY` transaction requests. This value is
        # nine consecutive zeros for Amazon Seller Wallet accounts.
        attribute?(:routing_number, String, from: "routingNumber")
      end
    end
  end
end
