# frozen_string_literal: true

# Fixture extracted from Amazon's online documentation.
# https://developer-docs.amazon.com/sp-api/docs/notification-type-values.md
#
# Note: Fixed property name from "detailPageTrafficEventNotifications" to "detailPageTrafficEvents"
# to match the actual schema.

require "helper"

module Peddler
  module Notifications
    class DetailPageTrafficEventTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/detail_page_traffic_event.json")
      end

      def test_parses_notification
        notification = DetailPageTrafficEvent.parse(@payload)

        assert_equal("DETAIL_PAGE_TRAFFIC_EVENT", notification.notification_type)
      end

      def test_parses_notification_metadata
        metadata = DetailPageTrafficEvent.parse(@payload).notification_metadata

        assert_kind_of(DetailPageTrafficEvent::NotificationMetadata, metadata)
        assert_equal("amzn1.sellerapps.app.aacccfff-4455-4b7c-4422-664ecacdd336", metadata.application_id)
        assert_equal("2023-02-07T16:45:32.378Z", metadata.publish_time)
      end
    end
  end
end
