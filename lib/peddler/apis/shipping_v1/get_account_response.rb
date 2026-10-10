# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The response schema for the getAccount operation.
      GetAccountResponse = Structure.new do
        # Encountered errors for the operation.
        attribute?(:errors, [Error])

        # The payload for getAccount operation
        attribute?(:payload, Account)
      end
    end
  end
end
