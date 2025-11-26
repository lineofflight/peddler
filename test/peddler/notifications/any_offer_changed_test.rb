# frozen_string_literal: true

# Fixture extracted from a real notification payload.

require "helper"

module Peddler
  module Notifications
    class AnyOfferChangedTest < Minitest::Test
      include FixtureHelpers

      def setup
        @payload = load_fixture("notifications/any_offer_changed.json")
      end

      def test_parses_notification
        notification = AnyOfferChanged.parse(@payload)

        assert_equal("ANY_OFFER_CHANGED", notification.notification_type)
      end
    end
  end
end
