# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/seller_wallet_2024_03_01/balance"

module Peddler
  module Types
    module SellerWallet20240301
      # Struct that holds list of balances on the seller account.
      BalanceListing = Structure.new do
        # @return [Array<Balance>] Collection that holds list of balances on the account
        attribute?(:balances, [Balance])
      end
    end
  end
end
