require 'peddler/parsers/model'
require 'mws/reports/parsers/report_request_info'

module MWS
  module Reports
    module Parsers
      class ReportRequest < Peddler::Parsers::Model
        value :info do
          ReportRequestInfo.new(at_xpath('ReportRequestInfo'))
        end
      end
    end
  end
end
