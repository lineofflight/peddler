require 'peddler/parsers/model'
require 'mws/reports/parsers/report_request'

module MWS
  module Reports
    module Parsers
      class ReportRequests < ::Peddler::Parsers::Model
        value :count do
          integer_at_xpath('Count')
        end

        def report_requests
          xpath('ReportRequestInfo').map { |node| ReportRequest.new(node) }
        end
      end
    end
  end
end
