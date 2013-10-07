require 'peddler/parsers/collection'
require 'mws/feeds/parsers/feed_submission'
require 'peddler/parsers/tokenable'

module MWS
  module Feeds
    module Parsers
      class FeedSubmissionList < ::Peddler::Parsers::Collection
        include ::Peddler::Parsers::Tokenable

        def each(&blk)
          feed_submission_nodes.each { |node| yield FeedSubmission.new(node) }
        end

        private

        def feed_submission_nodes
          xpath('FeedSubmissionInfo')
        end
      end
    end
  end
end
