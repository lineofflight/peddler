require 'peddler/request'
require 'mws/feeds/parsers/feed_submission_result'

module MWS
  module Feeds
    module Requests
      class FeedSubmissionResult < ::Peddler::Request
        def get(feed_submission_id)
          parameters(:get_feed_submission_result)
            .update(feed_submission_id: feed_submission_id)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
