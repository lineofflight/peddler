require 'peddler/request'
require 'mws/reports/parsers/report_schedule_count'

module MWS
  module Reports
    module Requests
      class ReportScheduleCount < ::Peddler::Request
        def get(*types)
          parameters('GetReportScheduleCount')
            .update(report_type_list: types)
            .format_structured_lists!
            .camelize_keys!

          execute
        end
      end
    end
  end
end
