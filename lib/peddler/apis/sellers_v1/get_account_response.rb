# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellersV1
      # The response schema for the `getAccount` operation.
      GetAccountResponse = Structure.new do
        # @return [Array<Error>] The errors encountered by the `getAccount` operation.
        attribute?(:errors, [Error])

        # @return [Account]
        attribute?(:payload, Account)
      end
    end
  end
end
