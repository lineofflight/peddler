# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerRepeatPurchase
      # Report options specifying parameters such as reportPeriod.
      ReportOptions = Structure.new do
        # @return [String] Determines what granularity of data is expected in the report. Valid values are: WEEK, MONTH,
        #   QUARTER.
        attribute(:report_period, String, from: "reportPeriod")
      end
    end
  end
end
