require 'peddler/request'
require 'mws/feeds/parsers/feed_submissions'

module MWS
  module Feeds
    module Requests
      class FeedSubmissions < ::Peddler::Request
        def cancel(options = {})
          parameters(:cancel_feed_submissions)
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

