require 'peddler/request'
require 'mws/feeds/parsers/feed_submission_list'

module MWS
  module Feeds
    module Requests
      class FeedSubmissionList < ::Peddler::Request
        def get(options = {})
          parameters('GetFeedSubmissionList')
            .update(options)
            .timestamp!
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def get_by_next_token(token = next_token)
          return false unless token

          parameters('GetFeedSubmissionListByNextToken')
            .update(next_token: token)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
