# frozen_string_literal: true

# Fixture extracted from Amazon's online documentation.
# https://developer-docs.amazon.com/sp-api/docs/notification-type-values.md

require "helper"

module Peddler
  module Notifications
    class ListingsItemStatusChangeTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/listings_item_status_change.json")
      end

      def test_parses_notification
        notification = ListingsItemStatusChange.parse(@payload)

        assert_equal("LISTINGS_ITEM_STATUS_CHANGE", notification.notification_type)
      end
    end
  end
end
