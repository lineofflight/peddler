# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class Feeds20210630Test < Minitest::Test
      include FeatureHelpers

      def test_get_feeds
        res = api.get_feeds(
          feed_types: ["POST_PRODUCT_DATA"],
          page_size: 10,
          processing_statuses: ["CANCELLED", "DONE"],
        )

        assert_success(res)
      end

      def test_get_feed
        res = api.get_feed(feed_id: "feedId1")

        assert_success(res)
      end

      def test_create_feed_document
        res = api.create_feed_document(body: { "contentType" => "text/tab-separated-values; charset=UTF-8" })

        assert_success(res)
      end

      def test_get_feed_document
        res = api.get_feed_document(feed_document_id: "0356cf79-b8b0-4226-b4b9-0ee058ea5760")

        assert_success(res)
      end
    end
  end
end
