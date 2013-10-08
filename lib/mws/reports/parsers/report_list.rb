require 'peddler/parsers/collection'
require 'mws/reports/parsers/report_info'
require 'peddler/parsers/tokenable'

module MWS
  module Reports
    module Parsers
      class ReportList < ::Peddler::Parsers::Collection
        include ::Peddler::Parsers::Tokenable

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
