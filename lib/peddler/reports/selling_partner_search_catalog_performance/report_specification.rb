# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellingPartnerSearchCatalogPerformance
      # Summarizes the original report request.
      ReportSpecification = Structure.new do
        # @return [Date] The end date of the report (Amazon ignores the time component). For WEEK, MONTH, and QUARTER
        # reportPeriods, this value must correspond to the last day in the reportPeriod that you specify or else a fatal
        # error returns. For example, dataEndTime must be a Saturday for the WEEK reportPeriod.
        attribute(:data_end_time, Date, from: "dataEndTime")

        # @return [Date] The start date of the report (Amazon ignores the time component). For WEEK, MONTH, and QUARTER
        # reportPeriods, this value must correspond to the first day in the reportPeriod that you specify or else a
        # fatal error returns. For example, dataStartTime must be a Sunday for the WEEK reportPeriod.
        attribute(:data_start_time, Date, from: "dataStartTime")

        # @return [Array<String>] This parameter must match the marketplaceId of the selling partner account. This
        # report type supports only one marketplaceId per report. If you specify multiple marketplaces, a fatal error
        # returns and report generation fails.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [ReportOptions] The report options that specify parameters, such as reportPeriod.
        attribute(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] The type of the report.
        attribute(:report_type, String, from: "reportType")
      end
    end
  end
end
