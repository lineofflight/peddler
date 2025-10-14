# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellingPartnerMarketBasketAnalysis
      # Summarizes the original report request.
      ReportSpecification = Structure.new do
        # @return [Date] The end date of the report (any time component is ignored). For WEEK, MONTH and QUARTER
        # reportPeriods, this value must correspond to the last day in the specified reportPeriod or else a fatal error
        # is returned. For example, dataEndTime must be a Saturday for the WEEK reportPeriod.
        attribute(:data_end_time, Date, from: "dataEndTime")

        # @return [Date] The start date of the report (any time component is ignored). For WEEK, MONTH and QUARTER
        # reportPeriods, this value must correspond to the first day in the specified reportPeriod or else a fatal error
        # is returned. For example, dataStartTime must be a Sunday for the WEEK reportPeriod.
        attribute(:data_start_time, Date, from: "dataStartTime")

        # @return [Array] This parameter must match the marketplaceId of the selling partner account. This report type
        # supports only one marketplaceId per report. Specifying multiple marketplaces will result in a fatal error and
        # fail to generate the report.
        attribute(:marketplace_ids, Array, from: "marketplaceIds")

        # @return [ReportOptions] Report options specifying parameters such as reportPeriod.
        attribute(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] Type of the report.
        attribute(:report_type, String, from: "reportType")
      end
    end
  end
end
