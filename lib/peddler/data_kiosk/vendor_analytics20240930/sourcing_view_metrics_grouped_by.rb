# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Sourcing view metrics grouped by the selected "group by" attributes, e.g., brand, ASIN.
      SourcingViewMetricsGroupedBy = Structure.new do
        # @return [GroupByAttributes] Group by attributes, e.g., brand, ASIN.
        attribute?(:group_by_key, GroupByAttributes, from: "groupByKey")

        # @return [SourcingViewMetrics] Metrics for the given time period, grouped by the attributes selected in the
        # groupByKey.
        attribute?(:metrics, SourcingViewMetrics)
      end
    end
  end
end
