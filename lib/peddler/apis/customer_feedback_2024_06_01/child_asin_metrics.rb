# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The review topic metrics for other child ASINs that have the same parent ASIN. This value is `null` if there
      # isn't any child ASIN metric data.
      ChildASINMetrics = Structure.new do
        # @return [ChildASINMentionMetrics] The child ASIN for which reviews mention the topic the least number of
        # times, and the number of times reviews mention the topic. This value is `null` if there are no child ASIN
        # metrics.
        attribute?(:least_mentions, ChildASINMentionMetrics, from: "leastMentions")

        # @return [ChildASINMentionMetrics] The child ASIN for which reviews mention the topic the greatest number of
        # times, and the number of times reviews mention the topic. This value is `null` if there are no child ASIN
        # metrics.
        attribute?(:most_mentions, ChildASINMentionMetrics, from: "mostMentions")
      end
    end
  end
end
