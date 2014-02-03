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

      end
    end
  end
end
