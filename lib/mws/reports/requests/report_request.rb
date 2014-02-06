require 'peddler/request'
require 'mws/reports/parsers/report_request'

module MWS
  module Reports
    module Requests
      class ReportRequest < ::Peddler::Request
        def submit(type, options = {})
          parameters('RequestReport')
            .update(report_type: type)
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
