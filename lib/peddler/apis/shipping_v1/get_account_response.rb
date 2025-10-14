# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The response schema for the getAccount operation.
      GetAccountResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])

        # @return [Account] The payload for getAccount operation
        attribute?(:payload, Account)
      end
    end
  end
end
