# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Customer return topics metric group. A null value for a given metric means that the metric is not available.
      CustomerReturnTopics = Structure.new do
        # @return [String] Month-over-month trends of the ten most common topics based on customer return
        # comments aggregated across all ASINs within the browse node (product category)
        # associated with this ASIN. For each topic, the occurrence percentage is shown
        # for each of the past six months.
        attribute?(:browse_node_return_topic_trends, String, from: "browseNodeReturnTopicTrends")

        # @return [String] The ten most common topics based on customer return comments, aggregated
        # across all ASINs within the browse node (product category) associated with
        # this ASIN, along with the occurrence percentage of each topic.
        attribute?(:browse_node_return_topics, String, from: "browseNodeReturnTopics")
      end
    end
  end
end
