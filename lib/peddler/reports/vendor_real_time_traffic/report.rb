# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorRealTimeTraffic
      # This report shares data on the customer traffic to the detail pages of the vendor's items with an hourly
      # granularity. Requests can span multiple date range periods. For example, if the customer specified dataStartTime
      # and dataEndTime span three hours, the report would contain data for each complete hour within the time span.
      Report = Structure.new do
        # List of hour and ASIN combinations.
        attribute(:report_data, [ReportData], null: false, from: "reportData")

        # Summarizes the original report request.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")
      end
    end
  end
end
