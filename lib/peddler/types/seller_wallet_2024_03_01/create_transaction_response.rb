# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/seller_wallet_2024_03_01/transaction"

module Peddler
  module Types
    module SellerWallet20240301
      # The transaction response and historical details related to it.
      CreateTransactionResponse = Structure.new do
        # @return [Transaction] The transaction response details.
        attribute(:transaction, Transaction)

        # @return [String] The callback URL for the transaction which the user have to click to approve/consent the
        # transaction
        attribute(:call_back_url, String, from: "callBackURL")
      end
    end
  end
end
