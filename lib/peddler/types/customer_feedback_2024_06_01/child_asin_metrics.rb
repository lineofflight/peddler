# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/customer_feedback_2024_06_01/child_asin_mention_metrics"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The review topic metrics for other child ASINs that have the same parent ASIN. This value is `null` if there
      # isn't any child ASIN metric data.
      ChildAsinMetrics = Structure.new do
        # @return [ChildAsinMentionMetrics] The child ASIN for which reviews mention the topic the least number of
        # times, and the number of times reviews mention the topic. This value is `null` if there are no child ASIN
        # metrics.
        attribute?(:least_mentions, ChildAsinMentionMetrics, from: "leastMentions")

        # @return [ChildAsinMentionMetrics] The child ASIN for which reviews mention the topic the greatest number of
        # times, and the number of times reviews mention the topic. This value is `null` if there are no child ASIN
        # metrics.
        attribute?(:most_mentions, ChildAsinMentionMetrics, from: "mostMentions")
      end
    end
  end
end
