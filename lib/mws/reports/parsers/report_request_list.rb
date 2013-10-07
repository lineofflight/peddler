require 'peddler/parsers/collection'
require 'mws/reports/parsers/report_request'
require 'peddler/parsers/tokenable'

module MWS
  module Reports
    module Parsers
      class ReportRequestList < ::Peddler::Parsers::Collection
        include ::Peddler::Parsers::Tokenable

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
