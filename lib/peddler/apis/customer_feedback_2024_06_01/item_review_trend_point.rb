# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The review metrics for a certain month.
      ItemReviewTrendPoint = Structure.new do
        # @return [ReviewTrendMetrics] The ASIN's review trend metrics.
        attribute(:asin_metrics, ReviewTrendMetrics, from: "asinMetrics")

        # @return [DateRange] The date range of the item review trend metric.
        attribute(:date_range, DateRange, from: "dateRange")

        # @return [BrowseNodeTrendMetrics] The browse node's review trend metrics. This value is `null` if there isn't
        #   enough topic data for the browse node.
        attribute?(:browse_node_metrics, BrowseNodeTrendMetrics, from: "browseNodeMetrics")

        # @return [ReviewTrendMetrics] The parent ASIN's review trend metrics. This value is `null` if there isn't
        #   enough topic data for the parent ASIN.
        attribute?(:parent_asin_metrics, ReviewTrendMetrics, from: "parentAsinMetrics")
      end
    end
  end
end
