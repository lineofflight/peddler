# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Feeds
    module ListingsFeedSchema
      # Selling Partner Listings Feed (v2)
      Feed = Structure.new do
        # @return [Header] Header information about the feed submission.
        attribute(:header, Header, null: false)

        # @return [Array<Message>] Messages containing listings data submissions for the Selling Partner.
        attribute(:messages, [Message], null: false)
      end
    end
  end
end
