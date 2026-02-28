# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # ReportingDateRange with start timestamp and end timestamp defined.
      ReportingDateRange = Structure.new do
        # @return [String] Reporting start date in UTC.
        attribute(:reporting_date_from, String, null: false, from: "reportingDateFrom")

        # @return [String] Reporting end date in UTC.
        attribute(:reporting_date_to, String, null: false, from: "reportingDateTo")
      end
    end
  end
end
