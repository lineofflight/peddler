# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The error response schema for the `UpdateShipmentStatus` operation.
      UpdateShipmentStatusErrorResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `UpdateShipmentStatus` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
