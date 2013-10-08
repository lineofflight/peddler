require 'peddler/parsers/model'
require 'mws/feeds/parsers/feed_submission_info'

module MWS
  module Feeds
    module Parsers
      class FeedSubmissions < ::Peddler::Parsers::Model
        value :count do
          integer_at_xpath('Count')
        end

        def feed_submissions
          xpath('FeedSubmissionInfo').map { |node| FeedSubmissionInfo.new(node) }
        end
      end
    end
  end
end
