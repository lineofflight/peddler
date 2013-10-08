require 'peddler/parsers/model'
require 'mws/feeds/parsers/feed_submission_info'

module MWS
  module Feeds
    module Parsers
      class Feed < Peddler::Parsers::Model
        value :submission_info do
          FeedSubmissionInfo.new(at_xpath('FeedSubmissionInfo'))
        end
      end
    end
  end
end
