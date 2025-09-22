# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/reports_2021_06_30/report"

module Peddler
  module Types
    module Reports20210630
      # The response for the `getReports` operation.
      GetReportsResponse = Structure.new do
        # @return [Array<Report>] The reports.
        attribute(:reports, [Report])

        # @return [String] Returned when the number of results exceeds `pageSize`. To get the next page of results, call
        # `getReports` with this token as the only parameter.
        attribute(:next_token, String, from: "nextToken")
      end
    end
  end
end
