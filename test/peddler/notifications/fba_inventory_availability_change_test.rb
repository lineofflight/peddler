# frozen_string_literal: true

# Fixture extracted from Amazon's online documentation.
# https://developer-docs.amazon.com/sp-api/docs/notification-type-values.md

require "helper"

module Peddler
  module Notifications
    class FBAInventoryAvailabilityChangeTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/fba_inventory_availability_change.json")
      end

      def test_parses_notification
        notification = FBAInventoryAvailabilityChange.parse(@payload)

        assert_equal("FBA_INVENTORY_AVAILABILITY_CHANGES", notification.notification_type)
      end
    end
  end
end
