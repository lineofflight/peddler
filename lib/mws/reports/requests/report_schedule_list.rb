require 'peddler/request'
require 'mws/reports/parsers/report_schedule_list'

module MWS
  module Reports
    module Requests
      class ReportScheduleList < ::Peddler::Request
        def get(*types)
          parameters(:get_report_schedule_list)
            .update(report_type_list: types)
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def get_by_next_token(token = next_token)
          raise NotImplementedError
        end
      end
    end
  end
end
