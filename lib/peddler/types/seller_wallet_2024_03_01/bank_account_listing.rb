# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/seller_wallet_2024_03_01/bank_account"

module Peddler
  module Types
    module SellerWallet20240301
      # Struct that holds collection of accounts.
      BankAccountListing = Structure.new do
        # @return [Array<BankAccount>] Collection that holds BankAccount
        attribute(:accounts, [BankAccount])
      end
    end
  end
end
