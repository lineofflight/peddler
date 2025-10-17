# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module EndUserData
      # Used to specify the report period.
      ReportOptions = Structure.new do
        # @return [String] The granularity of the data in the report. Valid values are: DAY, WEEK, and MONTH. If no
        #   granularity is specified, reportPeriod defaults to MONTH.
        attribute?(:report_period, String, from: "reportPeriod")
      end
    end
  end
end
