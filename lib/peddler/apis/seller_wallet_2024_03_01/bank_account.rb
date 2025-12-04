# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Details of an Amazon Seller Wallet bank account. This account is used to hold the money that a Seller Wallet
      # customer earns by selling items.
      BankAccount = Structure.new do
        # @return [String] The two digit country code, in ISO 3166 format.
        attribute(:account_country_code, String, from: "accountCountryCode")

        # @return [String] BankAccount currency code in ISO 4217 format
        attribute(:account_currency, String, from: "accountCurrency")

        # @return [String] Last 3 digit of the bank account number, for all Amazon Seller Wallet account the value will
        #   be three consecutive 0's
        attribute(:bank_account_number_tail, String, from: "bankAccountNumberTail")

        # @return [String] Type of ownership of the bank account. This value is `SELF` for Amazon Seller Wallet
        #   accounts.
        attribute(:bank_account_ownership_type, String, from: "bankAccountOwnershipType")

        # @return [String] The bank account holder's name (expected to be an Amazon customer). There is a 50 character
        #   limit.
        attribute?(:account_holder_name, String, from: "accountHolderName")

        # @return [String] The unique bank account identifier provided by Amazon. To initiate a `SELF` transaction with
        #   Seller Wallet, you must choose `BANK_ACCOUNT` as the payment method type in the
        #   [getPaymentMethod](https://developer-docs.amazon.com/sp-api/reference/getpaymentmethods) request. Your
        #   Amazon Seller Wallet bank account identifier should match the `paymentMethodId` in the response. This field
        #   is required.
        attribute?(:account_id, String, from: "accountId")

        # @return [String] Bank account holder compliance status
        attribute?(:bank_account_holder_status, String, from: "bankAccountHolderStatus")

        # @return [String] The format in which the bank account number is provided for `THIRD_PARTY` transaction
        #   requests.
        attribute?(:bank_account_number_format, String, from: "bankAccountNumberFormat")

        # @return [String] The name of the bank. This value is Amazon Seller Wallet for Amazon Seller Wallet accounts.
        attribute?(:bank_name, String, from: "bankName")

        # @return [String] The bank number format or routing number type for `THIRD_PARTY` transaction requests.
        attribute?(:bank_number_format, String, from: "bankNumberFormat")

        # @return [String] Routing number for automated clearing house transfers for `THIRD_PARTY` transaction requests.
        #   This value is nine consecutive zeros for Amazon Seller Wallet accounts.
        attribute?(:routing_number, String, from: "routingNumber")
      end
    end
  end
end
