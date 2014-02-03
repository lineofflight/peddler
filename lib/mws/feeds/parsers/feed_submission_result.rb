require 'peddler/parsers/model'

module MWS
  module Feeds
    module Parsers
      class FeedSubmissionResult < ::Peddler::Parsers::Model

        value :message_type do
          text_at_xpath('MessageType')
        end

        private

        def add_namespace(path)
          path
        end
      end
    end
  end
end
