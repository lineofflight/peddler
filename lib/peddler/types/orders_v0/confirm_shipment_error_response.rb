# frozen_string_literal: true

require "peddler/types/orders_v0/error"

module Peddler
  module Types
    module OrdersV0
      # The error response schema for the `confirmShipment` operation.
      ConfirmShipmentErrorResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `confirmShipment` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
