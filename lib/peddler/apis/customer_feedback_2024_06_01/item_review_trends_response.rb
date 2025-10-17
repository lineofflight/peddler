# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The response for the `getItemReviewTrends` operation.
      ItemReviewTrendsResponse = Structure.new do
        # @return [String] The requested ASIN. The Amazon Standard Identification Number (ASIN) is the unique identifier
        #   of a product within a marketplace.
        attribute(:asin, String)

        # @return [String] The two digit country code of the requested marketplace id, in ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, from: "countryCode")

        # @return [DateRange] The range of dates in which the reviews were made.
        attribute(:date_range, DateRange, from: "dateRange")

        # @return [String] The product title of the requested ASIN.
        attribute(:item_name, String, from: "itemName")

        # @return [String] The requested marketplace id.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [ItemReviewTrends] The item review trends.
        attribute(:review_trends, ItemReviewTrends, from: "reviewTrends")
      end
    end
  end
end
