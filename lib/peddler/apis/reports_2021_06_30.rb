# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Reports
    #
    # The Selling Partner API for Reports lets you retrieve and manage a variety of reports that can help selling
    # partners manage their businesses.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/reports-api-model/reports_2021-06-30.json
    module Reports20210630
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "reports_2021_06_30.create_report" => -> { CreateReportResponse },
        "reports_2021_06_30.create_report_schedule" => -> { CreateReportScheduleResponse },
        "reports_2021_06_30.get_report" => -> { Report },
        "reports_2021_06_30.get_report_document" => -> { ReportDocument },
        "reports_2021_06_30.get_report_schedule" => -> { ReportSchedule },
        "reports_2021_06_30.get_report_schedules" => -> { ReportScheduleList },
        "reports_2021_06_30.get_reports" => -> { GetReportsResponse },
      })
    end
  end
end
