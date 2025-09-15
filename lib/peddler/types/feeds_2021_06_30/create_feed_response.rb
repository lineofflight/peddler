# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module Feeds20210630
      # Response schema.
      CreateFeedResponse = Structure.new do
        # @return [String] The identifier for the feed. This identifier is unique only in combination with a seller ID.
        attribute(:feed_id, String, from: "feedId")
      end
    end
  end
end
