# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerMarketBasketAnalysis
      # Report options specifying parameters such as reportPeriod.
      ReportOptions = Structure.new do
        # @return [String] The granularity of the data in the report. Valid values are: DAY, WEEK, MONTH, QUARTER.
        attribute(:report_period, String, from: "reportPeriod")
      end
    end
  end
end
