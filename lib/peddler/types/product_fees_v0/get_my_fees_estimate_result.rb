# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_fees_v0/fees_estimate_result"

module Peddler
  module Types
    module ProductFeesV0
      # Response schema.
      GetMyFeesEstimateResult = Structure.new do
        # @return [FeesEstimateResult] The item's estimated fees.
        attribute(:fees_estimate_result, FeesEstimateResult, from: "FeesEstimateResult")
      end
    end
  end
end
