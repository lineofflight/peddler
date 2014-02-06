require 'peddler/request'
require 'mws/reports/parsers/report_requests'

module MWS
  module Reports
    module Requests
      class ReportRequests < ::Peddler::Request
        def cancel(options = {})
          parameters('CancelReportRequests')
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
