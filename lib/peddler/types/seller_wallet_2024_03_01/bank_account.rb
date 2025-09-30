# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module SellerWallet20240301
      # Details of an Amazon SW bank account, used to hold money earned by a SW customer by selling items. NOTE: Not
      # including account_links, short cut links to the account balance and transactions -> since not mandatory
      BankAccount = Structure.new do
        # @return [String] The unique identifier provided by Amazon to identify the account
        attribute?(:account_id, String, from: "accountId")

        # @return [String] BankAccount holder's name (expected to be Amazon customer)
        attribute?(:account_holder_name, String, from: "accountHolderName")

        # @return [String] Format in which the Bank BankAccount is provided
        attribute(:bank_account_number_format, String, from: "bankAccountNumberFormat")

        # @return [String] The name of the bank, for all Amazon Seller Wallet account the value will be Amazon Seller
        # Wallet
        attribute?(:bank_name, String, from: "bankName")

        # @return [String] Type of the Bank BankAccount is provided, for all Amazon Seller Wallet account the value will
        # be SELF
        attribute(:bank_account_ownership_type, String, from: "bankAccountOwnershipType")

        # @return [String] Routing number for automated clearing house transfers, for all Amazon Seller Wallet account
        # the value will be denoted by nine cosecutive 0's,
        attribute(:routing_number, String, from: "routingNumber")

        # @return [String] Bank account number format or routing number type.
        attribute(:bank_number_format, String, from: "bankNumberFormat")

        # @return [String] The two digit country code, in ISO 3166 format.
        attribute(:account_country_code, String, from: "accountCountryCode")

        # @return [String] BankAccount currency code in ISO 4217 format
        attribute(:account_currency, String, from: "accountCurrency")

        # @return [String] Last 3 digit of the bank account number, for all Amazon Seller Wallet account the value will
        # be three consecutive 0's
        attribute(:bank_account_number_tail, String, from: "bankAccountNumberTail")

        # @return [String] Bank account holder compliance status
        attribute?(:bank_account_holder_status, String, from: "bankAccountHolderStatus")
      end
    end
  end
end
