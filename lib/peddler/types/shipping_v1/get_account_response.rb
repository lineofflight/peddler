# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/error"
require "peddler/types/shipping_v1/account"

module Peddler
  module Types
    module ShippingV1
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
