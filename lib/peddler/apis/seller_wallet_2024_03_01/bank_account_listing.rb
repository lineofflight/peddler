# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Struct that holds collection of accounts.
      BankAccountListing = Structure.new do
        # @return [Array<BankAccount>] Collection that holds BankAccount
        attribute(:accounts, [BankAccount], null: false)
      end
    end
  end
end
