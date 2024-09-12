# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Feeds
    #
    # The Selling Partner API for Feeds lets you upload data to Amazon on behalf of a selling partner.
    class Feeds20210630 < API
      # Returns feed details for the feeds that match the filters that you specify.
      #
      # @param [Array<String>] feed_types A list of feed types used to filter feeds. When feedTypes is provided, the
      #   other filter parameters (processingStatuses, marketplaceIds, createdSince, createdUntil) and pageSize may also
      #   be provided. Either feedTypes or nextToken is required.
      # @param [Array<String>] marketplace_ids A list of marketplace identifiers used to filter feeds. The feeds
      #   returned will match at least one of the marketplaces that you specify.
      # @param [Integer] page_size The maximum number of feeds to return in a single call.
      # @param [Array<String>] processing_statuses A list of processing statuses used to filter feeds.
      # @param [String] created_since The earliest feed creation date and time for feeds included in the response, in
      #   ISO 8601 format. The default is 90 days ago. Feeds are retained for a maximum of 90 days.
      # @param [String] created_until The latest feed creation date and time for feeds included in the response, in ISO
      #   8601 format. The default is now.
      # @param [String] next_token A string token returned in the response to your previous request. nextToken is
      #   returned when the number of results exceeds the specified pageSize value. To get the next page of results,
      #   call the getFeeds operation and include this token as the only parameter. Specifying nextToken with any other
      #   parameters will cause the request to fail.
      # @return [Hash] The API response
      def get_feeds(feed_types: nil, marketplace_ids: nil, page_size: nil, processing_statuses: nil,
        created_since: nil, created_until: nil, next_token: nil)
        path = "/feeds/2021-06-30/feeds"
        params = {
          "feedTypes" => feed_types,
          "marketplaceIds" => marketplace_ids,
          "pageSize" => page_size,
          "processingStatuses" => processing_statuses,
          "createdSince" => created_since,
          "createdUntil" => created_until,
          "nextToken" => next_token,
        }.compact

        rate_limit(0.0222).get(path, params:)
      end

      # Creates a feed. Upload the contents of the feed document before calling this operation.
      #
      # @param [Hash] body Information required to create the feed.
      # @return [Hash] The API response
      def create_feed(body)
        path = "/feeds/2021-06-30/feeds"
        body = body

        rate_limit(0.0083).post(path, body:)
      end

      # Cancels the feed that you specify. Only feeds with `processingStatus=IN_QUEUE` can be cancelled. Cancelled feeds
      # are returned in subsequent calls to the
      # [`getFeed`](https://developer-docs.amazon.com/sp-api/docs/feeds-api-v2021-06-30-reference#getfeed) and
      # [`getFeeds`](https://developer-docs.amazon.com/sp-api/docs/feeds-api-v2021-06-30-reference#getfeeds) operations.
      #
      # @param [String] feed_id The identifier for the feed. This identifier is unique only in combination with a seller
      #   ID.
      # @return [Hash] The API response
      def cancel_feed(feed_id)
        path = "/feeds/2021-06-30/feeds/#{feed_id}"

        rate_limit(2.0).delete(path)
      end

      # Returns feed details (including the `resultDocumentId`, if available) for the feed that you specify.
      #
      # @param [String] feed_id The identifier for the feed. This identifier is unique only in combination with a seller
      #   ID.
      # @return [Hash] The API response
      def get_feed(feed_id)
        path = "/feeds/2021-06-30/feeds/#{feed_id}"

        rate_limit(2.0).get(path)
      end

      # Creates a feed document for the feed type that you specify. This operation returns a presigned URL for uploading
      # the feed document contents. It also returns a `feedDocumentId` value that you can pass in with a subsequent call
      # to the [`createFeed`](https://developer-docs.amazon.com/sp-api/docs/feeds-api-v2021-06-30-reference#createfeed)
      # operation.
      #
      # @param [Hash] body Specifies the content type for the createFeedDocument operation.
      # @return [Hash] The API response
      def create_feed_document(body)
        path = "/feeds/2021-06-30/documents"
        body = body

        rate_limit(0.5).post(path, body:)
      end

      # Returns the information required for retrieving a feed document's contents.
      #
      # @param [String] feed_document_id The identifier of the feed document.
      # @return [Hash] The API response
      def get_feed_document(feed_document_id)
        path = "/feeds/2021-06-30/documents/#{feed_document_id}"

        rate_limit(0.0222).get(path)
      end
    end
  end
end
