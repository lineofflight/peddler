# frozen_string_literal: true

# Fixture extracted from Amazon's online documentation.
# https://developer-docs.amazon.com/sp-api/docs/notification-type-values.md

require "helper"

module Peddler
  module Notifications
    class B2BAnyOfferChangedTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/b2b_any_offer_changed.json")
      end

      def test_parses_notification
        notification = B2BAnyOfferChanged.parse(@payload)

        assert_equal("B2B_ANY_OFFER_CHANGED", notification.notification_type)
      end
    end
  end
end
