# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def seller_wallet_2024_03_01(...)
      APIs::SellerWallet20240301.new(...)
    end
  end

  module APIs
    # The Selling Partner API for Amazon Seller Wallet Open Banking API
    # The Selling Partner API for Seller Wallet (Seller Wallet API) provides financial information that is relevant to a
    # seller's Seller Wallet account. You can obtain financial events, balances, and transfer schedules for Seller
    # Wallet accounts. You can also schedule and initiate transactions.
    class SellerWallet20240301 < API
      # Get all Seller Wallet accounts for a given seller.
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] The marketplace for which items are returned. The marketplace ID is the globally
      #   unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def list_accounts(marketplace_id)
        path = "/finances/transfers/wallet/2024-03-01/accounts"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        get(path, params:)
      end

      # Retrieve an Amazon Seller Wallet bank account by Amazon account identifier.
      # @note This operation can make a static sandbox call.
      # @param account_id [String] The ID of the Amazon Seller Wallet account.
      # @return [Peddler::Response] The API response
      def get_account(account_id)
        path = "/finances/transfers/wallet/2024-03-01/accounts/#{percent_encode(account_id)}"

        get(path)
      end

      # Retrieve the balance in a given Amazon Seller Wallet bank account.
      # @note This operation can make a static sandbox call.
      # @param account_id [String] The ID of the Amazon Seller Wallet account.
      # @return [Peddler::Response] The API response
      def list_account_balances(account_id)
        path = "/finances/transfers/wallet/2024-03-01/accounts/#{percent_encode(account_id)}/balance"

        get(path)
      end

      # Retrieve a list of potential fees on a transaction.
      # @note This operation can make a static sandbox call.
      # @param source_country_code [String] Country code of the source transaction account in ISO 3166 format.
      # @param source_currency_code [String] Currency code of the source transaction country in ISO 4217 format.
      # @param destination_country_code [String] Country code of the destination transaction account in ISO 3166 format.
      # @param destination_currency_code [String] Currency code of the destination transaction country in ISO 4217
      #   format.
      # @param base_amount [Number] The base transaction amount without any markup fees.
      # @return [Peddler::Response] The API response
      def get_transfer_preview(source_country_code, source_currency_code, destination_country_code,
        destination_currency_code, base_amount)
        path = "/finances/transfers/wallet/2024-03-01/transferPreview"
        params = {
          "sourceCountryCode" => source_country_code,
          "sourceCurrencyCode" => source_currency_code,
          "destinationCountryCode" => destination_country_code,
          "destinationCurrencyCode" => destination_currency_code,
          "baseAmount" => base_amount,
        }.compact

        get(path, params:)
      end

      # Retrieve a list of transactions for a given Amazon Seller Wallet bank account.
      # @note This operation can make a static sandbox call.
      # @param account_id [String] The ID of the Amazon Seller Wallet account.
      # @param next_page_token [String] A token that you use to retrieve the next page of results. The response includes
      #   `nextPageToken` when the number of results exceeds 100. To get the next page of results, call the operation
      #   with this token and include the same arguments as the call that produced the token. To get a complete list,
      #   call this operation until `nextPageToken` is null. Note that this operation can return empty pages.
      # @return [Peddler::Response] The API response
      def list_account_transactions(account_id, next_page_token: nil)
        path = "/finances/transfers/wallet/2024-03-01/transactions"
        params = {
          "accountId" => account_id,
          "nextPageToken" => next_page_token,
        }.compact

        get(path, params:)
      end

      # Create a transaction request from an Amazon Seller Wallet account to another customer-provided account.
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The payload of the request
      # @param dest_account_digital_signature [String] Digital signature for the destination bank account details.
      # @param amount_digital_signature [String] Digital signature for the source currency transaction amount.
      # @return [Peddler::Response] The API response
      def create_transaction(body, dest_account_digital_signature, amount_digital_signature)
        path = "/finances/transfers/wallet/2024-03-01/transactions"

        post(path, body:)
      end

      # Find a transaction by the Amazon transaction identifier.
      # @note This operation can make a static sandbox call.
      # @param transaction_id [String] The ID of the Amazon Seller Wallet transaction.
      # @return [Peddler::Response] The API response
      def get_transaction(transaction_id)
        path = "/finances/transfers/wallet/2024-03-01/transactions/#{percent_encode(transaction_id)}"

        get(path)
      end

      # Returns all transfer schedules of a given Amazon Seller Wallet bank account with the schedule ID in response if
      # present.
      # @note This operation can make a static sandbox call.
      # @param account_id [String] The ID of the Amazon Seller Wallet account.
      # @param next_page_token [String] A token that you use to retrieve the next page of results. The response includes
      #   `nextPageToken` when the number of results exceeds the specified `pageSize` value. To get the next page of
      #   results, call the operation with this token and include the same arguments as the call that produced the
      #   token. To get a complete list, call this operation until `nextPageToken` is null. Note that this operation can
      #   return empty pages.
      # @return [Peddler::Response] The API response
      def list_transfer_schedules(account_id, next_page_token: nil)
        path = "/finances/transfers/wallet/2024-03-01/transferSchedules"
        params = {
          "accountId" => account_id,
          "nextPageToken" => next_page_token,
        }.compact

        get(path, params:)
      end

      # Create a transfer schedule request from an Amazon Seller Wallet account to another customer-provided account.
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The payload of the request.
      # @param dest_account_digital_signature [String] Digital signature for the destination bank account details.
      # @param amount_digital_signature [String] Digital signature for the source currency transaction amount.
      # @return [Peddler::Response] The API response
      def create_transfer_schedule(body, dest_account_digital_signature, amount_digital_signature)
        path = "/finances/transfers/wallet/2024-03-01/transferSchedules"

        post(path, body:)
      end

      # Update transfer schedule information. Returns a transfer belonging to the updated scheduled transfer request.
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The payload of the scheduled transfer request that is to be updated.
      # @param dest_account_digital_signature [String] Digital signature for the destination bank account details.
      # @param amount_digital_signature [String] Digital signature for the source currency transaction amount.
      # @return [Peddler::Response] The API response
      def update_transfer_schedule(body, dest_account_digital_signature, amount_digital_signature)
        path = "/finances/transfers/wallet/2024-03-01/transferSchedules"

        put(path, body:)
      end

      # Find a particular Amazon Seller Wallet account transfer schedule.
      # @note This operation can make a static sandbox call.
      # @param transfer_schedule_id [String] The schedule ID of the Amazon Seller Wallet transfer.
      # @return [Peddler::Response] The API response
      def get_transfer_schedule(transfer_schedule_id)
        path = "/finances/transfers/wallet/2024-03-01/transferSchedules/#{percent_encode(transfer_schedule_id)}"

        get(path)
      end

      # Delete a transaction request that is scheduled from Amazon Seller Wallet account to another customer-provided
      # account.
      # @note This operation can make a static sandbox call.
      # @param transfer_schedule_id [String] A unique reference ID for a scheduled transfer.
      # @return [Peddler::Response] The API response
      def delete_schedule_transaction(transfer_schedule_id)
        path = "/finances/transfers/wallet/2024-03-01/transferSchedules/#{percent_encode(transfer_schedule_id)}"

        delete(path)
      end
    end
  end
end
