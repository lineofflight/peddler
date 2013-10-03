require 'peddler/parsers/model'
require 'mws/feeds/parsers/feed_submission'

module MWS
  module Feeds
    module Parsers
      class Feed < Peddler::Parsers::Model
        value :submission do
          FeedSubmission.new(document.xpath('xmlns:FeedSubmissionInfo').first)
        end
      end
    end
  end
end
