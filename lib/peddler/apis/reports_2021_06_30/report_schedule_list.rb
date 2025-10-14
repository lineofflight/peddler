# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Reports20210630
      # A list of report schedules.
      ReportScheduleList = Structure.new do
        # @return [Array<ReportSchedule>] Detailed information about a report schedule.
        attribute(:report_schedules, [ReportSchedule], from: "reportSchedules")
      end
    end
  end
end
