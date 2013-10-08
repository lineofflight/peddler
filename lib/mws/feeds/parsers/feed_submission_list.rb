require 'peddler/parsers/collection'
require 'mws/feeds/parsers/feed_submission_info'
require 'peddler/parsers/tokenable'

module MWS
  module Feeds
    module Parsers
      class FeedSubmissionList < ::Peddler::Parsers::Collection
        include ::Peddler::Parsers::Tokenable

        def each(&blk)
          feed_submission_info_nodes.each { |node| yield FeedSubmissionInfo.new(node) }
        end

        private

        def feed_submission_info_nodes
          xpath('FeedSubmissionInfo')
        end
      end
    end
  end
end
