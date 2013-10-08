require 'peddler/request'
require 'mws/reports/parsers/report'

module MWS
  module Reports
    module Requests
      class Report < ::Peddler::Request
        def get(id)
          parameters(:get_report)
            .update(report_id: id)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
