# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/seller_wallet_2024_03_01/transaction"

module Peddler
  module Types
    module SellerWallet20240301
      # Struct that holds collection of transactions.
      TransactionListing = Structure.new do
        # @return [String] If present, use this pagination token to retrieve the next page of supply sources, if not
        # provided the API will return same response. The field will only be provided when the list is greater than 100.
        attribute(:next_page_token, String, from: "nextPageToken")

        # @return [Array<Transaction>] Collection that holds Transaction
        attribute(:transactions, [Transaction])
      end
    end
  end
end
