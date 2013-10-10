require 'peddler/parsers/model'

module MWS
  module Reports
    module Parsers
      class ReportSchedule < ::Peddler::Parsers::Model
        value :type do
          text_at_xpath('ReportType')
        end

        value :schedule do
          text_at_xpath('Schedule')
        end

        value :scheduled_at do
          time_at_xpath('ScheduledDate')
        end
      end
    end
  end
end
