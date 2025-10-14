# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The `competitiveSummary` batch request data.
      CompetitiveSummaryBatchRequest = Structure.new do
        # @return [Array<CompetitiveSummaryRequest>] A batched list of `competitiveSummary` requests.
        attribute(:requests, [CompetitiveSummaryRequest])
      end
    end
  end
end
