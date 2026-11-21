# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellersV1
      # The response schema for the `getAccount` operation.
      GetAccountResponse = Structure.new do
        # The errors encountered by the `getAccount` operation.
        attribute?(:errors, [Error])

        attribute?(:payload, Account)
      end
    end
  end
end
