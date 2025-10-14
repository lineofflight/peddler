# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Struct that holds list of balances on the seller account.
      BalanceListing = Structure.new do
        # @return [Array<Balance>] Collection that holds list of balances on the account
        attribute?(:balances, [Balance])
      end
    end
  end
end
