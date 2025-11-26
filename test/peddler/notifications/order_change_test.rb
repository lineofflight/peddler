# frozen_string_literal: true

# Fixture extracted from Amazon's online documentation.
# https://developer-docs.amazon.com/sp-api/docs/tutorial-subscribe-to-order-change-notification.md

require "helper"

module Peddler
  module Notifications
    class OrderChangeTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/order_change.json")
      end

      def test_parses_notification
        notification = OrderChange.parse(@payload)

        assert_equal("ORDER_CHANGE", notification.notification_type)
      end
    end
  end
end
