# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/error"

module Peddler
  module Types
    module OrdersV0
      # The error response schema for the `UpdateVerificationStatus` operation.
      UpdateVerificationStatusErrorResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `UpdateVerificationStatus` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
