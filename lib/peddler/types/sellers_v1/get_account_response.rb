# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/sellers_v1/account"
require "peddler/types/sellers_v1/error"

module Peddler
  module Types
    module SellersV1
      # The response schema for the `getAccount` operation.
      GetAccountResponse = Structure.new do
        # @return [Account]
        attribute?(:payload, Account)

        # @return [Array<Error>] The errors encountered by the `getAccount` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
