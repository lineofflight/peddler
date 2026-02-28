# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class CustomerFeedback20240601
      # The response for the `getItemReviewTopics` operation.
      ItemReviewTopicsResponse = Structure.new do
        # @return [String] The requested ASIN. The Amazon Standard Identification Number (ASIN) is the unique identifier
        #   of a product within a marketplace.
        attribute(:asin, String, null: false)

        # @return [String] The two digit country code of the requested marketplace id, in ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # @return [DateRange] The date range of the item review topics.
        attribute(:date_range, DateRange, null: false, from: "dateRange")

        # @return [String] The product title of the requested ASIN.
        attribute(:item_name, String, null: false, from: "itemName")

        # @return [String] The requested marketplace id.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [ItemReviewTopics] The item review topics for the requested ASIN.
        attribute(:topics, ItemReviewTopics, null: false)
      end
    end
  end
end
