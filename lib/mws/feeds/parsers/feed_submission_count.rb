require 'peddler/parsers/model'

module MWS
  module Feeds
    module Parsers
      class FeedSubmissionCount < ::Peddler::Parsers::Model
        value :count do
          integer_at_xpath('Count')
        end
      end
    end
  end
end
