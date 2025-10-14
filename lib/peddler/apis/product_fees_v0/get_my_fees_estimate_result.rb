# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductFeesV0
      # Response schema.
      GetMyFeesEstimateResult = Structure.new do
        # @return [FeesEstimateResult] The item's estimated fees.
        attribute?(:fees_estimate_result, FeesEstimateResult, from: "FeesEstimateResult")
      end
    end
  end
end
