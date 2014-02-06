require 'peddler/request'
require 'mws/reports/parsers/report'

module MWS
  module Reports
    module Requests
      class Report < ::Peddler::Request
        def get(id, &blk)
          parameters('GetReport')
            .update(report_id: id)
            .camelize_keys!

          execute(&blk)
        end
      end
    end
  end
end
