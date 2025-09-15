# frozen_string_literal: true

require "peddler/types/feeds_2021_06_30/feed"

module Peddler
  module Types
    module Feeds20210630
      # Response schema.
      GetFeedsResponse = Structure.new do
        # @return [Array<Feed>] The feeds.
        attribute(:feeds, [Feed])

        # @return [String] Returned when the number of results exceeds pageSize. To get the next page of results, call
        # the getFeeds operation with this token as the only parameter.
        attribute(:next_token, String, from: "nextToken")
      end
    end
  end
end
