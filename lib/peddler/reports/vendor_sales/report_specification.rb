# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorSales
      # The report summary including reporting date range, distributor view, selling program, and last updated date in
      # the input.
      ReportSpecification = Structure.new do
        # @return [Date] Determines the end date of the report - the time component is ignored. For WEEK, MONTH,
        #   QUARTER, and YEAR reportPeriods, this value must correspond to the last day in the specified reportPeriod.
        #   For example, dataEndTime must be a Saturday for the WEEK reportPeriod.
        attribute(:data_end_time, Date, null: false, from: "dataEndTime")

        # @return [Date] Determines the start date of the report - the time component is ignored. For WEEK, MONTH,
        #   QUARTER, and YEAR reportPeriods, this value must correspond to the first day in the specified reportPeriod.
        #   For example, dataStartTime must be a Sunday for the WEEK reportPeriod.
        attribute(:data_start_time, Date, null: false, from: "dataStartTime")

        # @return [Date] The date when the report was last updated. Follows the
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} Date format of YYYY-MM-DD.
        attribute(:last_updated_date, Date, null: false, from: "lastUpdatedDate")

        # @return [Array<String>] This parameter must match the marketplaceId of the selling partner account. Each
        #   selling partner account belongs to only one marketplaceId.
        attribute(:marketplace_ids, [String], null: false, from: "marketplaceIds")

        # @return [ReportOptions] Report options specifying parameters such as reportPeriod, distributorView, and
        #   sellingProgram.
        attribute(:report_options, ReportOptions, null: false, from: "reportOptions")

        # @return [String] The report type.
        attribute(:report_type, String, null: false, from: "reportType")
      end
    end
  end
end
