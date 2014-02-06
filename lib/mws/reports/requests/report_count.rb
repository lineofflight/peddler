require 'peddler/request'
require 'mws/reports/parsers/report_count'

module MWS
  module Reports
    module Requests
      class ReportCount < ::Peddler::Request
        def get(options = {})
          parameters('GetReportCount')
            .update(options)
            .timestamp!
            .format_structured_lists!
            .camelize_keys!

          execute
        end
      end
    end
  end
end
