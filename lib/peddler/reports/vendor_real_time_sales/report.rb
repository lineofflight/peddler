# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorRealTimeSales
      # This report shares sales data at an ASIN level, aggregated to an hourly granularity. Requests can span multiple
      # date range periods. For example, if the customer specified dataStartTime and dataEndTime span three hours, the
      # report would contain data for each complete hour within the time span.
      Report = Structure.new do
        # @return [Array<reportData>] List of hour and ASIN combinations.
        attribute(:report_data, [ReportData], null: false, from: "reportData")

        # @return [Hash] Summarizes the original report request.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")
      end
    end
  end
end
