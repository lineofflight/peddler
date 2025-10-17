# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Reports20210630
      # Information required to create the report.
      CreateReportSpecification = Structure.new do
        # @return [Array<String>] A list of marketplace identifiers. The report document's contents will contain data
        #   for all of the specified marketplaces, unless the report type indicates otherwise.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [String] The report type. Refer to [Report Type
        #   Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information.
        attribute(:report_type, String, from: "reportType")

        # @return [Time] The end of a date and time range, in {https://developer-docs.amazon.com/sp-api/docs/iso-8601
        #   ISO 8601} date time format, used for selecting the data to report. The default is now. The value must be
        #   prior to or equal to the current date and time. Not all report types make use of this.
        attribute?(:data_end_time, Time, from: "dataEndTime")

        # @return [Time] The start of a date and time range, in {https://developer-docs.amazon.com/sp-api/docs/iso-8601
        #   ISO 8601} date time format, used for selecting the data to report. The default is now. The value must be
        #   prior to or equal to the current date and time. Not all report types make use of this.
        attribute?(:data_start_time, Time, from: "dataStartTime")

        # @return [Hash]
        attribute?(:report_options, Hash, from: "reportOptions")
      end
    end
  end
end
