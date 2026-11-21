# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # The error response schema for the `UpdateVerificationStatus` operation.
      UpdateVerificationStatusErrorResponse = Structure.new do
        # One or more unexpected errors occurred during the `UpdateVerificationStatus` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
