# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/competitive_summary_request"

module Peddler
  module Types
    module ProductPricing20220501
      # The `competitiveSummary` batch request data.
      CompetitiveSummaryBatchRequest = Structure.new do
        # @return [Array<CompetitiveSummaryRequest>] A batched list of `competitiveSummary` requests.
        attribute(:requests, [CompetitiveSummaryRequest])
      end
    end
  end
end
