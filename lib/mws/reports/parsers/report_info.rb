require 'peddler/parsers/model'

module MWS
  module Reports
    module Parsers
      class ReportInfo < ::Peddler::Parsers::Model
        value :id do
          text_at_xpath('ReportId')
        end

        value :type do
          text_at_xpath('ReportType')
        end

        value :request_id do
          text_at_xpath('ReportRequestId')
        end

        value :available_at do
          time_at_xpath('AvailableDate')
        end

        value :acknowledged? do
          boolean_at_xpath('Acknowledged')
        end
      end
    end
  end
end
