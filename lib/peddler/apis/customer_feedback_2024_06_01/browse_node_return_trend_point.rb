# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The return metrics for a certain month.
      BrowseNodeReturnTrendPoint = Structure.new do
        # @return [BrowseNodeTrendMetrics] The browse node return metrics.
        attribute(:browse_node_metrics, BrowseNodeTrendMetrics, from: "browseNodeMetrics")

        # @return [DateRange] The range of dates during which the returns were made.
        attribute(:date_range, DateRange, from: "dateRange")
      end
    end
  end
end
