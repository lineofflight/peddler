# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # The manufacturing view provides metrics about products manufactured by the Vendor for the given time period,
      # including both totals (aggregate across all of the vendor catalog) and metrics grouped by, e.g., ASIN.
      ManufacturingView = Structure.new do
        # @return [String] End date of the time period.
        attribute?(:end_date, String, from: "endDate")

        # @return [String] The marketplace identifier for the associated metrics.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<ManufacturingViewMetricsGroupedBy>] Metrics for the given time period, grouped by, e.g., ASIN.
        attribute?(:metrics, [ManufacturingViewMetricsGroupedBy])

        # @return [String] Start date of the time period.
        attribute?(:start_date, String, from: "startDate")

        # @return [ManufacturingViewMetrics] Totals (aggregate across all of the vendor catalog) for the given time
        # period.
        attribute?(:totals, ManufacturingViewMetrics)
      end
    end
  end
end
