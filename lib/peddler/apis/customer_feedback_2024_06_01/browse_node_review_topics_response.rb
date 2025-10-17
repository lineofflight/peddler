# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The response for the `getBrowseNodeReviewTopics` operation.
      BrowseNodeReviewTopicsResponse = Structure.new do
        # @return [String] The requested browse node id. A browse node id is the unique identifier of a given browse
        #   node.
        attribute(:browse_node_id, String, from: "browseNodeId")

        # @return [String] The two digit country code of requested marketplace id, in ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, from: "countryCode")

        # @return [DateRange] The range of dates in which the reviews were made.
        attribute(:date_range, DateRange, from: "dateRange")

        # @return [String] The display name of the requested browse node id. The display name of the browse node as
        #   visible on the Amazon retail website.
        attribute(:display_name, String, from: "displayName")

        # @return [String] The requested marketplace id.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [BrowseNodeReviewTopics] The most positive and most negative topics for all items in the browse node.
        attribute(:topics, BrowseNodeReviewTopics)
      end
    end
  end
end
