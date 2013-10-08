require 'peddler/parsers/model'
require 'mws/reports/parsers/report_request_info'

module MWS
  module Reports
    module Parsers
      class ReportRequests < ::Peddler::Parsers::Model
        value :count do
          integer_at_xpath('Count')
        end

        def report_request_infos
          xpath('ReportRequestInfo').map { |node| ReportRequestInfo.new(node) }
        end
      end
    end
  end
end
