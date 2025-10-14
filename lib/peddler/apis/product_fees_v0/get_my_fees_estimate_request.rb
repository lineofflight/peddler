# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductFeesV0
      # Request schema.
      GetMyFeesEstimateRequest = Structure.new do
        # @return [FeesEstimateRequest]
        attribute?(:fees_estimate_request, FeesEstimateRequest, from: "FeesEstimateRequest")
      end
    end
  end
end
