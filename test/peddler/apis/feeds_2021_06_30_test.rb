# frozen_string_literal: true

require "helper"

require "peddler/apis/feeds_2021_06_30"

module Peddler
  module APIs
    class Feeds20210630Test < Minitest::Test
      include FeatureHelpers

      def test_create_feed_document
        res = api.create_feed_document(
          { "contentType" => "application/json; charset=UTF-8" },
        )

        assert_predicate(res.status, :created?)
      end

      def test_create_feed
        feed_document_id = "amzn1.tortuga.4.eu.123"

        payload = {
          "feedType" => "JSON_LISTINGS_FEED",
          "marketplaceIds" => Marketplace.ids("UK"),
          "inputFeedDocumentId" => feed_document_id,
        }
        res = api.create_feed(payload)

        assert_predicate(res.status, :accepted?)
      end

      def test_get_feed
        feed_id = "123"
        res = api.get_feed(feed_id)

        assert_predicate(res.status, :ok?)
      end

      def test_get_feed_document
        feed_document_id = "amzn1.tortuga.4.eu.123"
        res = api.get_feed_document(feed_document_id)

        assert_predicate(res.status, :ok?)

        # Just exploring the result feed document
        url = res.dig("url")
        res = HTTP.get(url)
        body = Zlib::GzipReader.new(res).read

        assert(JSON.parse(body))
      end
    end
  end
end
