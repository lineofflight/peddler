require 'peddler/request'
require 'mws/feeds/parsers/feed_submission_list'

module MWS
  module Feeds
    module Requests
      class FeedSubmissionList < ::Peddler::Request
        def get(options = {})
          parameters(:get_feed_submission_list)
            .update(options)
            .timestamp!
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def get_by_next_token
          parameters(:get_feed_submission_list_by_next_token)
            .update(next_token: next_token)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
