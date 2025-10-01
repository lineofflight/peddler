# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/api"

module Peddler
  class << self
    def seller_wallet_2024_03_01(...)
      APIs::SellerWallet20240301.new(...)
    end
  end

  module APIs
    # The Selling Partner API for Amazon Seller Wallet Open Banking API Spec.
    #
    # For more information, refer to the [Seller Wallet Open Banking API Use Case
    # Guide](doc:seller-wallet-open-banking-api-v2024-03-01-use-case-guide).
    #
    # The Selling Partner API for Seller Wallet (Seller Wallet API) provides financial information that is relevant to a
    # seller's Seller Wallet account. You can obtain financial events, balances, and transfer schedules for Seller
    # Wallet accounts. You can also schedule and initiate transactions.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/seller-wallet-api-model/sellerWallet_2024-03-01.json
    class SellerWallet20240301 < API
      # Get Seller Wallet accounts for a seller.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace for which items are returned.
      # @return [Peddler::Response] The API response
      def list_accounts(marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/accounts"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::BankAccountListing if typed?
        get(path, params:, parser:)
      end

      # Retrieve a Seller Wallet bank account by Amazon account identifier.
      #
      # @note This operation can make a static sandbox call.
      # @param account_id [String] ID of the Amazon SW account
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def get_account(account_id, marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/accounts/#{percent_encode(account_id)}"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::BankAccount if typed?
        get(path, params:, parser:)
      end

      # Retrieve the balance in a given Seller Wallet bank account.
      #
      # @note This operation can make a static sandbox call.
      # @param account_id [String] ID of the Amazon SW account
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def list_account_balances(account_id, marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/accounts/#{percent_encode(account_id)}/balance"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::BalanceListing if typed?
        get(path, params:, parser:)
      end

      # Returns list of potential fees on a transaction based on the source and destination country currency code
      #
      # @note This operation can make a static sandbox call.
      # @param source_country_code [String] Represents 2 character country code of source transaction account in ISO
      #   3166 standard format.
      # @param source_currency_code [String] Represents 3 letter currency code in ISO 4217 standard format of the source
      #   transaction country.
      # @param destination_country_code [String] Represents 2 character country code of destination transaction account
      #   in ISO 3166 standard format.
      # @param destination_currency_code [String] Represents 3 letter currency code in ISO 4217 standard format of the
      #   destination transaction country.
      # @param base_amount [Number] Represents the base transaction amount without any markup fees, rates that will be
      #   used to get the transfer preview.
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def get_transfer_preview(source_country_code, source_currency_code, destination_country_code,
        destination_currency_code, base_amount, marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/transferPreview"
        params = {
          "sourceCountryCode" => source_country_code,
          "sourceCurrencyCode" => source_currency_code,
          "destinationCountryCode" => destination_country_code,
          "destinationCurrencyCode" => destination_currency_code,
          "baseAmount" => base_amount,
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::TransferRatePreview if typed?
        get(path, params:, parser:)
      end

      # Retrieve a list of transactions for a given Seller Wallet bank account.
      #
      # @note This operation can make a static sandbox call.
      # @param account_id [String] ID of the Amazon SW account
      # @param next_page_token [String] Pagination token to retrieve a specific page of results.
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def list_account_transactions(account_id, marketplace_id, next_page_token: nil)
        path = "/finances/transfers/wallet/2024-03-01/transactions"
        params = {
          "accountId" => account_id,
          "nextPageToken" => next_page_token,
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::TransactionListing if typed?
        get(path, params:, parser:)
      end

      # Create a transaction request from a Seller Wallet account to another customer-provided account.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Defines the actual payload of the request
      # @param dest_account_digital_signature [String] Digital signature for the destination bank account details.
      # @param amount_digital_signature [String] Digital signature for the source currency transaction amount.
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def create_transaction(body, dest_account_digital_signature, amount_digital_signature, marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/transactions"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::CreateTransactionResponse if typed?
        post(path, body:, params:, parser:)
      end

      # Returns a transaction
      #
      # @note This operation can make a static sandbox call.
      # @param transaction_id [String] ID of the Amazon SW transaction
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def get_transaction(transaction_id, marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/transactions/#{percent_encode(transaction_id)}"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::Transaction if typed?
        get(path, params:, parser:)
      end

      # Retrieve transfer schedules of a Seller Wallet bank account.
      #
      # @note This operation can make a static sandbox call.
      # @param account_id [String] ID of the Amazon SW account
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param next_page_token [String] Pagination token to retrieve a specific page of results.
      # @return [Peddler::Response] The API response
      def list_transfer_schedules(account_id, marketplace_id, next_page_token: nil)
        path = "/finances/transfers/wallet/2024-03-01/transferSchedules"
        params = {
          "accountId" => account_id,
          "marketplaceId" => marketplace_id,
          "nextPageToken" => next_page_token,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::TransferScheduleListing if typed?
        get(path, params:, parser:)
      end

      # Create a transfer schedule request from a Seller Wallet account to another customer-provided account.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Defines the actual payload of the request
      # @param dest_account_digital_signature [String] Digital signature for the destination bank account details.
      # @param amount_digital_signature [String] Digital signature for the source currency transaction amount.
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def create_transfer_schedule(body, dest_account_digital_signature, amount_digital_signature, marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/transferSchedules"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::TransferSchedule if typed?
        post(path, body:, params:, parser:)
      end

      # Returns a transfer belonging to the updated scheduled transfer request
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Defines the actual payload of the scheduled transfer request that is to be updated.
      # @param dest_account_digital_signature [String] Digital signature for the destination bank account details.
      # @param amount_digital_signature [String] Digital signature for the source currency transaction amount.
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def update_transfer_schedule(body, dest_account_digital_signature, amount_digital_signature, marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/transferSchedules"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::TransferSchedule if typed?
        put(path, body:, params:, parser:)
      end

      # Find a particular Amazon Seller Wallet account transfer schedule.
      #
      # @note This operation can make a static sandbox call.
      # @param transfer_schedule_id [String] The schedule ID of the Amazon Seller Wallet transfer.
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def get_transfer_schedule(transfer_schedule_id, marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/transferSchedules/#{percent_encode(transfer_schedule_id)}"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::TransferSchedule if typed?
        get(path, params:, parser:)
      end

      # Delete a transaction request that is scheduled from Amazon Seller Wallet account to another customer-provided
      # account.
      #
      # @note This operation can make a static sandbox call.
      # @param transfer_schedule_id [String] A unique reference ID for a scheduled transfer.
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def delete_schedule_transaction(transfer_schedule_id, marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/transferSchedules/#{percent_encode(transfer_schedule_id)}"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::SellerWallet20240301::DeleteTransferSchedule if typed?
        delete(path, params:, parser:)
      end

      private

      def load_types
        require "peddler/types/seller_wallet_2024_03_01"
      end
    end
  end
end
