# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The response for the `getBrowseNodeReviewTrends` operation.
      BrowseNodeReviewTrendsResponse = Structure.new do
        # @return [String] The requested browse node id. A browse node id is the unique identifier of a given browse
        #   node.
        attribute(:browse_node_id, String, null: false, from: "browseNodeId")

        # @return [String] The two digit country code of requested marketplace id, in ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # @return [DateRange] The range of dates during which the reviews were made.
        attribute(:date_range, DateRange, null: false, from: "dateRange")

        # @return [String] The display name of the requested browse node id. The display name of the browse node as
        #   visible on the Amazon retail website.
        attribute(:display_name, String, null: false, from: "displayName")

        # @return [String] The requested marketplace id.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [BrowseNodeReviewTrends] Browse Node review trends.
        attribute(:review_trends, BrowseNodeReviewTrends, null: false, from: "reviewTrends")
      end
    end
  end
end
