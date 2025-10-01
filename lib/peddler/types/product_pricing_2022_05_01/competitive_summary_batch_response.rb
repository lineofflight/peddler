# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_2022_05_01/competitive_summary_response"

module Peddler
  module Types
    module ProductPricing20220501
      # The response schema for the `competitiveSummaryBatch` operation.
      CompetitiveSummaryBatchResponse = Structure.new do
        # @return [Array<CompetitiveSummaryResponse>] The response list for the `competitiveSummaryBatch` operation.
        attribute(:responses, [CompetitiveSummaryResponse])
      end
    end
  end
end
