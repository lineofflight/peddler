# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # The sourcing view provides metrics about products that are sourced directly from
      # the Vendor to Amazon (i.e., when the Vendor is a distributor)
      # for the given time period, including both totals (aggregate across all of the
      # vendor catalog) and metrics grouped by, e.g., ASIN.
      SourcingView = Structure.new do
        # @return [String] End date of the time period.
        attribute?(:end_date, String, from: "endDate")

        # @return [String] The marketplace identifier for the associated metrics.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<SourcingViewMetricsGroupedBy>] Metrics for the given time period, grouped by, e.g., ASIN.
        attribute?(:metrics, [SourcingViewMetricsGroupedBy])

        # @return [String] Start date of the time period.
        attribute?(:start_date, String, from: "startDate")

        # @return [SourcingViewMetrics] Totals (aggregate across all of the vendor catalog) for the given time period.
        attribute?(:totals, SourcingViewMetrics)
      end
    end
  end
end
