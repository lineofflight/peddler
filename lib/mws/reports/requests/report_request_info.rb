require 'peddler/request'
require 'mws/reports/parsers/report_request_info'

module MWS
  module Reports
    module Requests
      class ReportRequestInfo < ::Peddler::Request
        def request(type, options = {})
          parameters(:request_report)
            .update(type: type)
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
