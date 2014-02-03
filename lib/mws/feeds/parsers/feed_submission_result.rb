require 'peddler/parsers/model'
require 'peddler/parsers/xml_without_namespace'

module MWS
  module Feeds
    module Parsers
      class FeedSubmissionResult < ::Peddler::Parsers::Model
        include ::Peddler::Parsers::XMLWithoutNamespace

        value :message_type do
          text_at_xpath('MessageType')
        end

        value :status_code do
          text_at_xpath('Message/ProcessingReport/Summary/StatusCode')
        end

      end
    end
  end
end
