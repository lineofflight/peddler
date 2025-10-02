# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def customer_feedback_2024_06_01
      APIs::CustomerFeedback20240601
    end
  end

  module APIs
    # The Selling Partner API for CustomerFeedback
    #
    # The Selling Partner API for Customer Feedback (Customer Feedback API) provides information about customer reviews
    # and returns at both the item and browse node level.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/customer-feedback-api-model/customerFeedback_2024-06-01.json
    class CustomerFeedback20240601 < API
      # Retrieve an item's ten most positive and ten most negative review topics.
      #
      # @note This operation can make a static sandbox call.
      # @param asin [String] The Amazon Standard Identification Number (ASIN) is the unique identifier of a product
      #   within a marketplace. The value must be a child ASIN.
      # @param marketplace_id [String] The MarketplaceId is the globally unique identifier of a marketplace, you can
      #   refer to the marketplaceId here : https://developer-docs.amazon.com/sp-api/docs/marketplace-ids.
      # @param sort_by [String] The metric by which to sort data in the response.
      # @return [Peddler::Response] The API response
      def get_item_review_topics(asin, marketplace_id, sort_by)
        path = "/customerFeedback/2024-06-01/items/#{percent_encode(asin)}/reviews/topics"
        params = {
          "marketplaceId" => marketplace_id,
          "sortBy" => sort_by,
        }.compact
        parser = -> {
          require "peddler/types/customer_feedback_2024_06_01"
          Types::CustomerFeedback20240601::ItemReviewTopicsResponse
        }
        get(path, params:, parser:)
      end

      # This API returns the associated browse node of the requested ASIN. A browse node is a location in a browse tree
      # that is used for navigation, product classification, and website content on the Amazon retail website.
      #
      # @note This operation can make a static sandbox call.
      # @param asin [String] The Amazon Standard Identification Number (ASIN) is the unique identifier of a product
      #   within a marketplace.
      # @param marketplace_id [String] The MarketplaceId is the globally unique identifier of a marketplace, you can
      #   refer to the marketplaceId here : https://developer-docs.amazon.com/sp-api/docs/marketplace-ids.
      # @return [Peddler::Response] The API response
      def get_item_browse_node(asin, marketplace_id)
        path = "/customerFeedback/2024-06-01/items/#{percent_encode(asin)}/browseNode"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = -> {
          require "peddler/types/customer_feedback_2024_06_01"
          Types::CustomerFeedback20240601::BrowseNodeResponse
        }
        get(path, params:, parser:)
      end

      # Retrieve a browse node's ten most positive and ten most negative review topics.
      #
      # @note This operation can make a static sandbox call.
      # @param browse_node_id [String] The ID of a browse node. A browse node is a named location in a browse tree that
      #   is used for navigation, product classification, and website content.
      # @param marketplace_id [String] The MarketplaceId is the globally unique identifier of a marketplace, you can
      #   refer to the marketplaceId here : https://developer-docs.amazon.com/sp-api/docs/marketplace-ids.
      # @param sort_by [String] The metric by which to sort the data in the response.
      # @return [Peddler::Response] The API response
      def get_browse_node_review_topics(browse_node_id, marketplace_id, sort_by)
        path = "/customerFeedback/2024-06-01/browseNodes/#{percent_encode(browse_node_id)}/reviews/topics"
        params = {
          "marketplaceId" => marketplace_id,
          "sortBy" => sort_by,
        }.compact
        parser = -> {
          require "peddler/types/customer_feedback_2024_06_01"
          Types::CustomerFeedback20240601::BrowseNodeReviewTopicsResponse
        }
        get(path, params:, parser:)
      end

      # Retrieve an item's positive and negative review trends for the past six months.
      #
      # @note This operation can make a static sandbox call.
      # @param asin [String] The Amazon Standard Identification Number (ASIN) is the unique identifier of a product
      #   within a marketplace. This API takes child ASIN as an input.
      # @param marketplace_id [String] The MarketplaceId is the globally unique identifier of a marketplace, you can
      #   refer to the marketplaceId here : https://developer-docs.amazon.com/sp-api/docs/marketplace-ids.
      # @return [Peddler::Response] The API response
      def get_item_review_trends(asin, marketplace_id)
        path = "/customerFeedback/2024-06-01/items/#{percent_encode(asin)}/reviews/trends"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = -> {
          require "peddler/types/customer_feedback_2024_06_01"
          Types::CustomerFeedback20240601::ItemReviewTrendsResponse
        }
        get(path, params:, parser:)
      end

      # Retrieve the positive and negative review trends of items in a browse node for the past six months.
      #
      # @note This operation can make a static sandbox call.
      # @param browse_node_id [String] A browse node ID is a unique identifier of a browse node. A browse node is a
      #   named location in a browse tree that is used for navigation, product classification, and website content.
      # @param marketplace_id [String] The marketplace ID is the globally unique identifier of a marketplace. For more
      #   information, refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @return [Peddler::Response] The API response
      def get_browse_node_review_trends(browse_node_id, marketplace_id)
        path = "/customerFeedback/2024-06-01/browseNodes/#{percent_encode(browse_node_id)}/reviews/trends"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = -> {
          require "peddler/types/customer_feedback_2024_06_01"
          Types::CustomerFeedback20240601::BrowseNodeReviewTrendsResponse
        }
        get(path, params:, parser:)
      end

      # Retrieve the topics that customers mention when they return items in a browse node.
      #
      # @note This operation can make a static sandbox call.
      # @param browse_node_id [String] A browse node ID is a unique identifier for a browse node. A browse node is a
      #   named location in a browse tree that is used for navigation, product classification, and website content.
      # @param marketplace_id [String] The MarketplaceId is the globally unique identifier of a marketplace, you can
      #   refer to the marketplaceId here : https://developer-docs.amazon.com/sp-api/docs/marketplace-ids.
      # @return [Peddler::Response] The API response
      def get_browse_node_return_topics(browse_node_id, marketplace_id)
        path = "/customerFeedback/2024-06-01/browseNodes/#{percent_encode(browse_node_id)}/returns/topics"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = -> {
          require "peddler/types/customer_feedback_2024_06_01"
          Types::CustomerFeedback20240601::BrowseNodeReturnTopicsResponse
        }
        get(path, params:, parser:)
      end

      # Retrieve the trends of topics that customers mention when they return items in a browse node.
      #
      # @note This operation can make a static sandbox call.
      # @param browse_node_id [String] A browse node ID is a unique identifier of a browse node. A browse node is a
      #   named location in a browse tree that is used for navigation, product classification, and website content.
      # @param marketplace_id [String] The MarketplaceId is the globally unique identifier of a marketplace, you can
      #   refer to the marketplaceId here : https://developer-docs.amazon.com/sp-api/docs/marketplace-ids.
      # @return [Peddler::Response] The API response
      def get_browse_node_return_trends(browse_node_id, marketplace_id)
        path = "/customerFeedback/2024-06-01/browseNodes/#{percent_encode(browse_node_id)}/returns/trends"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = -> {
          require "peddler/types/customer_feedback_2024_06_01"
          Types::CustomerFeedback20240601::BrowseNodeReturnTrendsResponse
        }
        get(path, params:, parser:)
      end
    end
  end
end
