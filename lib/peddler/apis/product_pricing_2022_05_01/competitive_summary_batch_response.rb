# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The response schema for the `competitiveSummaryBatch` operation.
      CompetitiveSummaryBatchResponse = Structure.new do
        # @return [Array<CompetitiveSummaryResponse>] The response list for the `competitiveSummaryBatch` operation.
        attribute(:responses, [CompetitiveSummaryResponse])
      end
    end
  end
end
