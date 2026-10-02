# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Amazon Seller Wallet Open Banking API
    #
    # The Selling Partner API for Seller Wallet (Seller Wallet API) provides financial information that is relevant to a
    # seller's Seller Wallet account. You can obtain financial events, balances, and transfer schedules for Seller
    # Wallet accounts. You can also schedule and initiate transactions.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/seller-wallet-api-model/sellerWallet_2024-03-01.json
    module SellerWallet20240301
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "seller_wallet_2024_03_01.create_transaction" => -> { CreateTransactionResponse },
        "seller_wallet_2024_03_01.create_transfer_schedule" => -> { TransferSchedule },
        "seller_wallet_2024_03_01.delete_schedule_transaction" => -> { DeleteTransferSchedule },
        "seller_wallet_2024_03_01.get_account" => -> { BankAccount },
        "seller_wallet_2024_03_01.get_transaction" => -> { Transaction },
        "seller_wallet_2024_03_01.get_transfer_preview" => -> { TransferRatePreview },
        "seller_wallet_2024_03_01.get_transfer_schedule" => -> { TransferSchedule },
        "seller_wallet_2024_03_01.list_account_balances" => -> { BalanceListing },
        "seller_wallet_2024_03_01.list_account_transactions" => -> { TransactionListing },
        "seller_wallet_2024_03_01.list_accounts" => -> { BankAccountListing },
        "seller_wallet_2024_03_01.list_transfer_schedules" => -> { TransferScheduleListing },
        "seller_wallet_2024_03_01.update_transfer_schedule" => -> { TransferSchedule },
      }.freeze
    end
  end
end
