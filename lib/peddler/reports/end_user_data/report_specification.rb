# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module EndUserData
      # Summarizes the report request.
      ReportSpecification = Structure.new do
        # @return [Date] Determines the end date of the report - the time component is ignored. If the provided end date
        #   occurs mid-week or mid-month, the preceding Saturday for weekly reporting periods or the last day of the
        #   previous month for monthly reporting periods will be used instead. Additionally if the end date differs from
        #   the start date by more than 365 days, it will be adjusted to the closest end date with a maximum 365 day
        #   difference based on the selected reporting period.
        attribute(:data_end_time, Date, null: false, from: "dataEndTime")

        # @return [Date] Determines the start date of the report - the time component is ignored. If the provided start
        #   date occurs mid-week or mid-month, the following Sunday for weekly reporting periods or the first day of the
        #   next month for monthly reporting periods will be used instead.
        attribute(:data_start_time, Date, null: false, from: "dataStartTime")

        # @return [Array<String>] Any of the EU(8) marketplaces. DE, FR, IT, ES, NL, PL, SE and BE
        attribute(:marketplace_ids, [String], null: false, from: "marketplaceIds")

        # @return [String] The report type.
        attribute(:report_type, String, null: false, from: "reportType")

        # @return [ReportOptions] Used to specify the report period.
        attribute?(:report_options, ReportOptions, from: "reportOptions")
      end
    end
  end
end
