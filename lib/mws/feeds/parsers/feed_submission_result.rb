require 'peddler/parsers/model'
require 'peddler/parsers/xml_without_namespace'

module MWS
  module Feeds
    module Parsers
      class FeedSubmissionResult < ::Peddler::Parsers::Model
        include ::Peddler::Parsers::XMLWithoutNamespace

        SUMMARY = 'Message/ProcessingReport/Summary/'
        PROCESSING_REPORT = SUMMARY + 'ProcessingSummary/'

        value :message_type do
          text_at_xpath('MessageType')
        end

        value :status_code do
          text_at_xpath("#{SUMMARY}StatusCode")
        end

        [ :messages_processed, :messages_successful,
          :messages_with_error, :messages_with_warning].each do |key|

          value key do
            integer_at_xpath("#{PROCESSING_REPORT}#{symbol_to_xpath(key)}")
          end
        end

      end
    end
  end
end
