require 'peddler/request'
require 'mws/reports/parsers/report_scheduler'

module MWS
  module Reports
    module Requests
      class ReportScheduler < ::Peddler::Request
        def manage(type, schedule, scheduled_at = nil)
          options = {
            report_type: type,
            schedule: schedule
          }
          options.update(scheduled_date: scheduled_at) if scheduled_at

          parameters('ManageReportSchedule')
            .update(options)
            .timestamp!
            .camelize_keys!

          execute
        end

        def delete(type)
          manage(type, '_NEVER_')
        end
      end
    end
  end
end
