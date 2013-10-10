require 'peddler/parsers/collection'
require 'mws/reports/parsers/report_info'

module MWS
  module Reports
    module Parsers
      class ReportAcknowledgements < ::Peddler::Parsers::Collection
        def each(&blk)
          report_info_nodes.each { |node| yield ReportInfo.new(node) }
        end

        private

        def report_info_nodes
          xpath('ReportInfo')
        end
      end
    end
  end
end
