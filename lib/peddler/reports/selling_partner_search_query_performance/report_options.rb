# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchQueryPerformance
      # The report options that specify parameters, such as reportPeriod and asin.
      ReportOptions = Structure.new do
        # @return [String] A space-separated list of ASINs for which you can request the report. There is a
        #   200-character limit.
        attribute(:asin, String, null: false)

        # @return [String] The granularity of the data in the report. Valid values are WEEK, MONTH, and QUARTER.
        attribute(:report_period, String, null: false, from: "reportPeriod")
      end
    end
  end
end
