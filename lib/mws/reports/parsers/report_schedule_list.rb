require 'peddler/parsers/collection'
require 'mws/reports/parsers/report_schedule'
require 'peddler/parsers/tokenable'

module MWS
  module Reports
    module Parsers
      class ReportScheduleList < ::Peddler::Parsers::Collection
        include ::Peddler::Parsers::Tokenable

        def each(&blk)
          report_schedule_nodes.each { |node| yield ReportSchedule.new(node) }
        end

        private

        def report_schedule_nodes
          xpath('ReportSchedule')
        end
      end
    end
  end
end
