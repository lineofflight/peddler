# frozen_string_literal: true

require "peddler/types/product_fees_v0/get_my_fees_estimate_result"
require "peddler/types/product_fees_v0/error"

module Peddler
  module Types
    module ProductFeesV0
      # The response object for the GetMyFeesEstimate operation.
      GetMyFeesEstimateResponse = Structure.new do
        # @return [GetMyFeesEstimateResult] The payload for the operation.
        attribute(:payload, GetMyFeesEstimateResult)

        # @return [Array<Error>] A list of errors that may have occurred during the GetMyFeesEstimate operation.
        attribute(:errors, [Error])
      end
    end
  end
end
