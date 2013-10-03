require 'peddler/request'
require 'mws/feeds/parsers/feed_submission_count'

module MWS
  module Feeds
    module Requests
      class FeedSubmissionCount < ::Peddler::Request
        def get(options = {})
          parameters(:get_feed_submission_count)
            .update(options)
            .timestamp!
            .format_structured_lists!
            .camelize_keys!

          execute
        end
      end
    end
  end
end

