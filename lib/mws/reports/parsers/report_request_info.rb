require 'peddler/parsers/model'

module MWS
  module Reports
    module Parsers
      class ReportRequestInfo < ::Peddler::Parsers::Model
        value :id do
          text_at_xpath('ReportRequestId')
        end

        value :type do
          text_at_xpath('ReportType')
        end

        value :started_at do
          time_at_xpath('StartDate')
        end

        value :ended_at do
          time_at_xpath('EndDate')
        end

        value :scheduled? do
          boolean_at_xpath('Scheduled')
        end

        value :submitted_at do
          time_at_xpath('SubmittedDate')
        end

        value :processing_status do
          text_at_xpath('ReportProcessingStatus')
        end

        value :generated_report_id do
          text_at_xpath('GeneratedReportId')
        end

        value :started_processing_at do
          time_at_xpath('StartedProcessingDate')
        end

        value :completed_at do
          time_at_xpath('CompletedDate')
        end
      end
    end
  end
end
