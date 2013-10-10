require 'peddler/parsers/model'
require 'mws/reports/parsers/report_schedule'

module MWS
  module Reports
    module Parsers
      class ReportScheduler < ::Peddler::Parsers::Model
        value :count do
          integer_at_xpath('Count')
        end

        value :report_schedule do
          node = at_xpath('ReportSchedule')
          ReportSchedule.new(node) if node
        end
      end
    end
  end
end
