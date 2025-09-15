# frozen_string_literal: true

require "peddler/types/shipping_v1/account"
require "peddler/types/shipping_v1/error"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the getAccount operation.
      GetAccountResponse = Structure.new do
        # @return [Account] The payload for getAccount operation
        attribute(:payload, Account)

        # @return [Array<Error>] Encountered errors for the operation.
        attribute(:errors, [Error])
      end
    end
  end
end
