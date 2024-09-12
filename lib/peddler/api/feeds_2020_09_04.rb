# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Feeds
    #
    # Effective **June 27, 2024**, the Selling Partner API for Feeds v2020-09-04 will no longer be available and all
    # calls to it will fail. Integrations that rely on the Feeds API must migrate to [Feeds
    # v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/feeds-api-v2021-06-30-reference) to avoid service
    # disruption.
    class Feeds20200904 < API
      # Effective June 27, 2023, the `getFeeds` operation will no longer be available in the Selling Partner API for
      # Feeds v2020-09-04 and all calls to it will fail. Integrations that rely on this operation should migrate to
      # [Feeds v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/feeds-api-v2021-06-30-reference) to avoid
      # service disruption.
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
        path = "/feeds/2020-09-04/feeds"
        params = {
          "feedTypes" => feed_types,
          "marketplaceIds" => marketplace_ids,
          "pageSize" => page_size,
          "processingStatuses" => processing_statuses,
          "createdSince" => created_since,
          "createdUntil" => created_until,
          "nextToken" => next_token,
        }.compact

        get(path, params:)
      end

      # Effective June 27, 2023, the `createFeed` operation will no longer be available in the Selling Partner API for
      # Feeds v2020-09-04 and all calls to it will fail. Integrations that rely on this operation should migrate to
      # [Feeds v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/feeds-api-v2021-06-30-reference) to avoid
      # service disruption.
      #
      # @param [Hash] body
      # @return [Hash] The API response
      def create_feed(body)
        path = "/feeds/2020-09-04/feeds"
        body = body

        post(path, body:)
      end

      # Effective June 27, 2023, the `getFeed` operation will no longer be available in the Selling Partner API for
      # Feeds v2020-09-04 and all calls to it will fail. Integrations that rely on this operation should migrate to
      # [Feeds v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/feeds-api-v2021-06-30-reference) to avoid
      # service disruption.
      #
      # @param [String] feed_id The identifier for the feed. This identifier is unique only in combination with a seller
      #   ID.
      # @return [Hash] The API response
      def get_feed(feed_id)
        path = "/feeds/2020-09-04/feeds/#{feed_id}"

        get(path)
      end

      # Effective June 27, 2023, the `cancelFeed` operation will no longer be available in the Selling Partner API for
      # Feeds v2020-09-04 and all calls to it will fail. Integrations that rely on this operation should migrate to
      # [Feeds v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/feeds-api-v2021-06-30-reference) to avoid
      # service disruption.
      #
      # @param [String] feed_id The identifier for the feed. This identifier is unique only in combination with a seller
      #   ID.
      # @return [Hash] The API response
      def cancel_feed(feed_id)
        path = "/feeds/2020-09-04/feeds/#{feed_id}"

        delete(path)
      end

      # Effective June 27, 2023, the `createFeedDocument` operation will no longer be available in the Selling Partner
      # API for Feeds v2020-09-04 and all calls to it will fail. Integrations that rely on this operation should migrate
      # to [Feeds v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/feeds-api-v2021-06-30-reference) to avoid
      # service disruption.
      #
      # @param [Hash] body
      # @return [Hash] The API response
      def create_feed_document(body)
        path = "/feeds/2020-09-04/documents"
        body = body

        post(path, body:)
      end

      # Effective June 27, 2023, the `getFeedDocument` operation will no longer be available in the Selling Partner API
      # for Feeds v2020-09-04 and all calls to it will fail. Integrations that rely on this operation should migrate to
      # [Feeds v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/feeds-api-v2021-06-30-reference) to avoid
      # service disruption.
      #
      # @param [String] feed_document_id The identifier of the feed document.
      # @return [Hash] The API response
      def get_feed_document(feed_document_id)
        path = "/feeds/2020-09-04/documents/#{feed_document_id}"

        get(path)
      end
    end
  end
end
