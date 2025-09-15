# frozen_string_literal: true

require "peddler/types/reports_2021_06_30/report_schedule"

module Peddler
  module Types
    module Reports20210630
      # A list of report schedules.
      ReportScheduleList = Structure.new do
        # @return [Array<ReportSchedule>] Detailed information about a report schedule.
        attribute(:report_schedules, [ReportSchedule], from: "reportSchedules")
      end
    end
  end
end
