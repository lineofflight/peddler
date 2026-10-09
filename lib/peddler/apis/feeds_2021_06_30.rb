# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Feeds
    #
    # The Selling Partner API for Feeds lets you upload data to Amazon on behalf of a selling partner.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/feeds-api-model/feeds_2021-06-30.json
    module Feeds20210630
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "feeds_2021_06_30.create_feed" => -> { CreateFeedResponse },
        "feeds_2021_06_30.create_feed_document" => -> { CreateFeedDocumentResponse },
        "feeds_2021_06_30.get_feed" => -> { Feed },
        "feeds_2021_06_30.get_feed_document" => -> { FeedDocument },
        "feeds_2021_06_30.get_feeds" => -> { GetFeedsResponse },
      })
    end
  end
end
