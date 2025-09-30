# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_fees_v0/fees_estimate_request"

module Peddler
  module Types
    module ProductFeesV0
      # Request schema.
      GetMyFeesEstimateRequest = Structure.new do
        # @return [FeesEstimateRequest]
        attribute?(:fees_estimate_request, FeesEstimateRequest, from: "FeesEstimateRequest")
      end
    end
  end
end
