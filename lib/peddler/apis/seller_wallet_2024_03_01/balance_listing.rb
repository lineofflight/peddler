# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # A list of balances in the seller account.
      BalanceListing = Structure.new do
        # @return [Array<Balance>] A list of balances in the seller account.
        attribute?(:balances, [Balance])
      end
    end
  end
end
