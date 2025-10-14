# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchCatalogPerformance
      # The report options that specify parameters, such as reportPeriod.
      ReportOptions = Structure.new do
        # @return [String] The granularity of the data in the report. Valid values are WEEK, MONTH, and QUARTER.
        attribute(:report_period, String, from: "reportPeriod")

        # @return [String] A space-separated list of Amazon Standard Identification Number (ASINs) for which you can
        # request the report. If you do not provide ASINs, the report returns search catalog performance data for all
        # ASINs for which you are a brand owner. There is a 200-character limit.
        attribute?(:asins, String)
      end
    end
  end
end
