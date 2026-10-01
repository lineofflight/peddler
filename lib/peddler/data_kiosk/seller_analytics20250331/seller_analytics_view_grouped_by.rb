# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # SellerAnalytics view metrics grouped by the selected "group by" attributes, for example, brand, ASIN.
      SellerAnalyticsViewGroupedBy = Structure.new do
        # @return [GroupByAttributes] Group by attributes, for example, brand, ASIN.
        attribute?(:group_by_key, GroupByAttributes, null: false, from: "groupByKey")

        # @return [SellerAnalyticsViewMetrics] Metrics for the given time period, grouped by the attributes selected in
        #   the groupByKey.
        attribute?(:metrics, SellerAnalyticsViewMetrics, null: false)
      end
    end
  end
end
