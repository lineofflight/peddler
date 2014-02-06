require 'peddler/request'
require 'mws/reports/parsers/report_request_list'

module MWS
  module Reports
    module Requests
      class ReportRequestList < ::Peddler::Request
        def get(options = {})
          parameters('GetReportRequestList')
            .update(options)
            .timestamp!
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def get_by_next_token(token = next_token)
          return false unless token

          parameters('GetReportRequestListByNextToken')
            .update(next_token: token)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
