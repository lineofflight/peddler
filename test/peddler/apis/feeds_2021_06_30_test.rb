# frozen_string_literal: true

require "helper"
require "peddler/apis/feeds_2021_06_30"

module Peddler
  module APIs
    class Feeds20210630Test < Minitest::Test
      include FeatureHelpers

      def test_get_feeds
        res = api.sandbox.get_feeds(
          feed_types: ["POST_PRODUCT_DATA"],
          page_size: 10,
          processing_statuses: ["CANCELLED", "DONE"],
        )

        assert_predicate(res.status, :success?)
      end

      def test_get_feed
        res = api.sandbox.get_feed("feedId1")

        assert_predicate(res.status, :success?)
      end

      def test_create_feed_document
        res = api.sandbox.create_feed_document({ "contentType" => "text/tab-separated-values; charset=UTF-8" })

        assert_predicate(res.status, :success?)
      end

      def test_get_feed_document
        res = api.sandbox.get_feed_document("0356cf79-b8b0-4226-b4b9-0ee058ea5760")

        assert_predicate(res.status, :success?)
      end
    end
  end
end
