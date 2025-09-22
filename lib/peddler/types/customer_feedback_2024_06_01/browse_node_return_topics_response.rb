# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/customer_feedback_2024_06_01/date_range"
require "peddler/types/customer_feedback_2024_06_01/browse_node_return_topics"

module Peddler
  module Types
    module CustomerFeedback20240601
      # The response for the `getBrowseNodeReturnTopics` operation.
      BrowseNodeReturnTopicsResponse = Structure.new do
        # @return [String] The requested browse node id. A browse node id is the unique identifier of a given browse
        # node.
        attribute(:browse_node_id, String, from: "browseNodeId")

        # @return [String] The display name of the browse node, as visible on the Amazon retail website.
        attribute(:display_name, String, from: "displayName")

        # @return [String] The requested marketplace id.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The two digit country code of requested marketplace id, in ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, from: "countryCode")

        # @return [DateRange] The range of dates during which the returns were made.
        attribute(:date_range, DateRange, from: "dateRange")

        # @return [Array<BrowseNodeReturnTopics>] The list of browse node return topics.
        attribute(:topics, [BrowseNodeReturnTopics])
      end
    end
  end
end
