# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The error response schema for the `confirmShipment` operation.
      ConfirmShipmentErrorResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `confirmShipment` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
