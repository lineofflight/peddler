# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module MarketplaceASINPageViewMetrics
      # Summarizes the report request.
      ReportSpecification = Structure.new do
        # @return [Array<String>] Any of the EU(8) or UK marketplaces. DE, FR, IT, ES, NL, PL, SE, BE and UK
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [ReportOptions] Specifies the product type.
        attribute(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] The report type.
        attribute(:report_type, String, from: "reportType")

        # @return [Date] Determines the end date of the report - the time component is ignored. If the end date of the
        # report is not within the seven days from start date, the report will be cancelled. If the end date of the
        # report is not provided, it will default to the end date of the most recently available daily date.
        attribute?(:data_end_time, Date, from: "dataEndTime")

        # @return [Date] Determines the start date of the report - the time component is ignored. If the start date of
        # the report is more than seven days ago, the report will be cancelled. If the start date of the report is not
        # provided, it will default to the start date of the most recently available daily data.
        attribute?(:data_start_time, Date, from: "dataStartTime")
      end
    end
  end
end
