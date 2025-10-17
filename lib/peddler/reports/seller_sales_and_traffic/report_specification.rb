# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellerSalesAndTraffic
      # Report summary including specified reporting date range, dateGranularity, and asinGranularity in the input.
      ReportSpecification = Structure.new do
        # @return [Date] This parameter determines the end date of the report - the time component is ignored. For WEEK
        #   and MONTH dateGranularity, if this value does not correspond to the last day in the specified
        #   dateGranularity then the report end date will be expanded to include the last day of the reporting period
        #   for the dateGranularity specified. The last day of the reporting period for the WEEK dateGranularity is
        #   Saturday and the last day of the reporting period for the MONTH dateGranularity is the last day of the
        #   month. For example, if the specified dataEndTime is 3 days before the end date of a WEEK dateGranularity,
        #   the end date used to generate the report will be dataEndTime plus 3 days.
        attribute(:data_end_time, Date, from: "dataEndTime")

        # @return [Date] This parameter determines the start date of the report - the time component is ignored. If the
        #   start date of the report is more than two years ago, the report will be cancelled. For WEEK and MONTH
        #   dateGranularity, if this value does not correspond to the first day in the specified dateGranularity then
        #   the report start date will be expanded to include the first day of the reporting period for the
        #   dateGranularity specified. The first day of the reporting period for the WEEK dateGranularity is Sunday and
        #   the first day of the reporting period for the MONTH dateGranularity is the first day of the month. For
        #   example, if the specified dataStartTime is 3 days after the start date of a WEEK dateGranularity, then the
        #   start date used to generate the report will be dataStartTime minus 3 days.
        attribute(:data_start_time, Date, from: "dataStartTime")

        # @return [Array<String>] This parameter must match the marketplaceId of the seller's account. This report type
        #   supports only one marketplaceId per report. Specifying multiple marketplaces will result in failure to
        #   generate the report.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [ReportOptions] Report options specifying parameters such as dateGranularity and asinGranularity.
        attribute(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] Type of the report.
        attribute(:report_type, String, from: "reportType")
      end
    end
  end
end
