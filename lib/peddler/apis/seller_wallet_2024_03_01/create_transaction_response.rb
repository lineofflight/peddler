# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # The transaction response and historical details related to it.
      CreateTransactionResponse = Structure.new do
        # @return [String] The callback URL for the transaction which the user have to click to approve/consent the
        #   transaction
        attribute(:call_back_url, String, null: false, from: "callBackURL")

        # @return [Transaction] The transaction response details.
        attribute(:transaction, Transaction, null: false)
      end
    end
  end
end
