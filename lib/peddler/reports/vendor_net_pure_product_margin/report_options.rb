# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorNetPureProductMargin
      # Report options specifying parameters such as reportPeriod.
      ReportOptions = Structure.new do
        # @return [String] Determines the period by which data in the report is aggregated. Valid values are: DAY, WEEK,
        #   MONTH, QUARTER, YEAR.
        attribute(:report_period, String, from: "reportPeriod")
      end
    end
  end
end
