# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Feeds20210630
      # Response schema.
      CreateFeedResponse = Structure.new do
        # @return [String] The identifier for the feed. This identifier is unique only in combination with a seller ID.
        attribute(:feed_id, String, from: "feedId")
      end
    end
  end
end
