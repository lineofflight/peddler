# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Feeds20210630
      # Response schema.
      GetFeedsResponse = Structure.new do
        # @return [Array<Feed>] The feeds.
        attribute(:feeds, [Feed], null: false)

        # @return [String] Returned when the number of results exceeds pageSize. To get the next page of results, call
        #   the getFeeds operation with this token as the only parameter.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
