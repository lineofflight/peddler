require 'peddler/parsers/collection'
require 'mws/reports/parsers/report_request'

module MWS
  module Reports
    module Parsers
      class ReportRequestList < ::Peddler::Parsers::Collection
        def each(&blk)
          report_request_nodes.each { |node| yield ReportRequest.new(node) }
        end

        private

        def report_request_nodes
          xpath('ReportRequestInfo')
        end
      end
    end
  end
end
