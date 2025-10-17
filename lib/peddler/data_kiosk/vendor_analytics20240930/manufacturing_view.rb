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
        attribute?(:end_date, String, null: false, from: "endDate")

        # @return [String] The marketplace identifier for the associated metrics.
        attribute?(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Array<ManufacturingViewMetricsGroupedBy>] Metrics for the given time period, grouped by, e.g., ASIN.
        attribute?(:metrics, [ManufacturingViewMetricsGroupedBy], null: false)

        # @return [String] Start date of the time period.
        attribute?(:start_date, String, null: false, from: "startDate")

        # @return [ManufacturingViewMetrics] Totals (aggregate across all of the vendor catalog) for the given time
        #   period.
        attribute?(:totals, ManufacturingViewMetrics, null: false)
      end
    end
  end
end
