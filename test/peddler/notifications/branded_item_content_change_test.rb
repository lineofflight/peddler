# frozen_string_literal: true

# Fixture extracted from Amazon's online documentation.
# https://developer-docs.amazon.com/sp-api/docs/notification-type-values.md

require "helper"

module Peddler
  module Notifications
    class BrandedItemContentChangeTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/branded_item_content_change.json")
      end

      def test_parses_notification
        notification = BrandedItemContentChange.parse(@payload)

        assert_equal("BRANDED_ITEM_CONTENT_CHANGE", notification.notification_type)
      end
    end
  end
end
