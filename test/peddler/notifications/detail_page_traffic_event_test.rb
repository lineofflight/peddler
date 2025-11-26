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
    end
  end
end
