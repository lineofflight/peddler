require 'peddler/parsers/model'

module MWS
  module Feeds
    module Parsers
      class FeedSubmission < ::Peddler::Parsers::Model
        value :id do
          integer_at_xpath('FeedSubmissionId')
        end

        value :type do
          text_at_xpath('FeedType')
        end

        value :submitted_at do
          time_at_xpath('SubmittedDate')
        end

        value :processing_status do
          text_at_xpath('FeedProcessingStatus')
        end
      end
    end
  end
end
