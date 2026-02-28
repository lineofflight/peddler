# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The child ASIN review topic mention metrics.
      ChildASINMentionMetrics = Structure.new do
        # @return [String] The child ASIN of the requested item.
        attribute(:asin, String, null: false)

        # @return [Integer] The number of times reviews of the child ASIN mention the topic.
        attribute(:number_of_mentions, Integer, null: false, from: "numberOfMentions")
      end
    end
  end
end
