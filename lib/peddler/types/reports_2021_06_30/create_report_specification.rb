# frozen_string_literal: true

require "peddler/types/reports_2021_06_30/report_options"

module Peddler
  module Types
    module Reports20210630
      # Information required to create the report.
      CreateReportSpecification = Structure.new do
        # @return [ReportOptions]
        attribute(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] The report type. Refer to [Report Type
        # Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information.
        attribute(:report_type, String, from: "reportType")

        # @return [String] The start of a date and time range, in <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> date time format, used for
        # selecting the data to report. The default is now. The value must be prior to or equal to the current date and
        # time. Not all report types make use of this.
        attribute(:data_start_time, String, from: "dataStartTime")

        # @return [String] The end of a date and time range, in <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> date time format, used for
        # selecting the data to report. The default is now. The value must be prior to or equal to the current date and
        # time. Not all report types make use of this.
        attribute(:data_end_time, String, from: "dataEndTime")

        # @return [Array<String>] A list of marketplace identifiers. The report document's contents will contain data
        # for all of the specified marketplaces, unless the report type indicates otherwise.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")
      end
    end
  end
end
