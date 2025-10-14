# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductFeesV0
      # The response object for the GetMyFeesEstimate operation.
      GetMyFeesEstimateResponse = Structure.new do
        # @return [Array<Error>] A list of errors that may have occurred during the GetMyFeesEstimate operation.
        attribute?(:errors, [Error])

        # @return [GetMyFeesEstimateResult] The payload for the operation.
        attribute?(:payload, GetMyFeesEstimateResult)
      end
    end
  end
end
