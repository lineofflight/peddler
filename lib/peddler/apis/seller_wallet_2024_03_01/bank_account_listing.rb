# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # A list of bank accounts.
      BankAccountListing = Structure.new do
        # @return [Array<BankAccount>] A list of bank accounts.
        attribute(:accounts, [BankAccount], null: false)
      end
    end
  end
end
