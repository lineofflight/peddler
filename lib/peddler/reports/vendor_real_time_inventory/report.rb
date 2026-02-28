# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorRealTimeInventory
      # This report shares inventory data at an ASIN level, aggregated to an hourly granularity. Requests can span
      # multiple date range periods, including the current day.
      Report = Structure.new do
        # @return [Array<ReportData>] List of ASIN and inventory count combinations.
        attribute(:report_data, [ReportData], null: false, from: "reportData")

        # @return [Hash] Summarizes the original report request.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")
      end
    end
  end
end
