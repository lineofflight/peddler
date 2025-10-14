# frozen_string_literal: true

require "helper"

module Peddler
  module Feeds
    class ListingsFeedProcessingReportSchemaTest < Minitest::Test
      include FixtureHelpers

      def setup
        @data = load_fixture("feeds/listings_feed_processing_report_with_optional_fields.json")
      end

      def test_parses_feed_structure
        feed = ListingsFeedProcessingReportSchema.parse(@data)

        assert_instance_of(ListingsFeedProcessingReportSchema::Feed, feed)
      end

      def test_parses_header
        feed = ListingsFeedProcessingReportSchema.parse(@data)

        assert_instance_of(ListingsFeedProcessingReportSchema::Header, feed.header)
      end

      def test_parses_nested_report
        feed = ListingsFeedProcessingReportSchema.parse(@data)

        assert_instance_of(ListingsFeedProcessingReportSchema::Report, feed.header.report)
      end

      def test_parses_issues_array
        feed = ListingsFeedProcessingReportSchema.parse(@data)

        assert_instance_of(ListingsFeedProcessingReportSchema::Issue, feed.issues.sample)
      end

      def test_parses_summary
        feed = ListingsFeedProcessingReportSchema.parse(@data)

        assert_instance_of(ListingsFeedProcessingReportSchema::Summary, feed.summary)
      end

      def test_parses_nested_item_summary
        feed = ListingsFeedProcessingReportSchema.parse(@data)

        assert_instance_of(ListingsFeedProcessingReportSchema::ItemSummary, feed.summary.item_summary)
      end

      def test_items_remains_flexible_array
        feed = ListingsFeedProcessingReportSchema.parse(@data)

        assert_instance_of(Array, feed.items)
        assert_empty(feed.items)
      end

      def test_parses_feed_without_optional_fields
        data = load_fixture("feeds/listings_feed_processing_report_without_optional_fields.json")

        feed = ListingsFeedProcessingReportSchema.parse(data)

        assert_instance_of(ListingsFeedProcessingReportSchema::Feed, feed)
        assert_nil(feed.header.report)
        assert_nil(feed.summary.item_summary)
      end
    end
  end
end
