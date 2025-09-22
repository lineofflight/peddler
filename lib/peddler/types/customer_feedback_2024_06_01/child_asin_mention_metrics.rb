# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The child ASIN review topic mention metrics.
      ChildAsinMentionMetrics = Structure.new do
        # @return [String] The child ASIN of the requested item.
        attribute(:asin, String)

        # @return [Integer] The number of times reviews of the child ASIN mention the topic.
        attribute(:number_of_mentions, Integer, from: "numberOfMentions")
      end
    end
  end
end
